# flake8: noqa
import os
import sys
import subprocess
import json
from pprint import pp
import tempfile
from pathlib import Path
import argparse
import httpx
import dns.zone
import dns.rdtypes
from dns.name import Name

SOPS_BIN = "@sops@"
DNS_SECRETS_FILE = "@dns_secrets_file@"
data_str = "@data@"
DATA = json.loads(data_str)

secrets_json = subprocess.check_output([SOPS_BIN, "-d", DNS_SECRETS_FILE])
secrets = json.loads(secrets_json)

AUTH_ID = secrets["auth_id"]
AUTH_PASSWORD = secrets["auth_password"]

BASE_URL = "https://api.cloudns.net"


def req(path: str, **kwargs):
    auth_params = {
        "auth-id": AUTH_ID,
        "auth-password": AUTH_PASSWORD,
    }

    params = {k.replace("_", "-"): v for k, v in kwargs.items()}

    return httpx.get(BASE_URL + path, params={**auth_params, **params}).json()


def textify(z: dns.zone.Zone) -> str:
    for node in z.nodes.values():
        node.rdatasets.sort(
            key=lambda rrd: (rrd.rdclass, rrd.rdtype, rrd.covers, rrd.ttl)
        )
    return z.to_text(
        sorted=True, relativize=True, nl="\n", want_comments=False, want_origin=True
    )


def set_soa_serial(zone: dns.zone.Zone, serial: int):
    origin = zone.origin
    if not isinstance(origin, Name):
        raise Exception(f"Bad zone origin {origin!r}")
    soa = zone.find_rdataset(origin, "SOA")
    thing = soa.processing_order()
    assert len(thing) == 1
    old_soa = thing[0]
    new_soa = old_soa.replace(serial=serial)

    soa.clear()
    soa.add(new_soa)


def display_and_maybe_update(origin: str, update: bool) -> bool:
    desired_zone = dns.zone.from_text(DATA[origin], origin=origin)

    res = req("/dns/records-export.json", domain_name=origin)
    current_zone_str = res["zone"]
    current_zone = dns.zone.from_text(current_zone_str, origin=origin)

    assert desired_zone.rdclass == current_zone.rdclass
    assert desired_zone.origin == current_zone.origin

    # cloudns makes its own serial, we can't change it.
    # set desired serial to match current serial
    current_serial = current_zone.get_soa().serial
    set_soa_serial(desired_zone, current_serial)

    current_text = textify(current_zone)
    desired_text = textify(desired_zone)
    if current_text == desired_text:
        print("No difference")
        return False

    with tempfile.TemporaryDirectory() as tmpdir:
        current = Path(f"{tmpdir}/current-zone.bind")
        current.write_text(current_text)
        desired = Path(f"{tmpdir}/desired-zone.bind")
        desired.write_text(desired_text)
        os.system(f"git diff --no-index {current} {desired}")

    if not update:
        return True
    user_input = input("Do you want to continue? (y/n): ").strip().lower()

    if user_input != "y":
        print("Abort.")
        sys.exit(1)

    res = req(
        "/dns/records-import.json",
        domain_name=origin,
        format="bind",
        content=desired_text,
        delete_existing_records=1,
    )
    pp(res)
    return True


parser = argparse.ArgumentParser()
parser.add_argument("--domain")
parser.add_argument("--all-domains", action="store_true")
parser.add_argument("--update", action="store_true")
args = parser.parse_args()

all_domains = bool(args.all_domains)
update = bool(args.update)

assert (args.domain is not None) != all_domains

if all_domains:
    assert args.domain is None
    domains = DATA.keys()
else:
    assert args.domain is not None
    domains = [args.domain]

found_any_difference = False
for domain in domains:
    print(domain)
    print("---------")
    found_difference = display_and_maybe_update(origin=domain, update=update)
    found_any_difference = found_any_difference or found_difference
    print()

if found_any_difference and not update:
    print("pass --update to make the changes shown")
