#!/usr/bin/env nix-shell
#!nix-shell --pure -i python3 -p "python3.withPackages (ps: with ps; [ requests ])"

import json
import re
import requests
import sys

releases = ("openjdk8", "openjdk9", "openjdk10", "openjdk11", "openjdk12", "openjdk13", "openjdk14", "openjdk15", "openjdk16")
nightlys = ('openjdk16')
oses = ("mac", "linux")
types = ("jre", "jdk")
impls = ("hotspot", "openj9")

arch_to_nixos = {
    "x64": ("x86_64",),
    "aarch64": ("aarch64",),
    "arm": ("armv6l", "armv7l"),
}

def get_sha256(url):
    resp = requests.get(url)
    if resp.status_code != 200:
        print("error: could not fetch checksum from url {}: code {}".format(url, resp.code), file=sys.stderr)
        sys.exit(1)
    return resp.text.strip().split(" ")[0]

def generate_sources(release, assets):
    out = {}
    for asset in assets:
        if asset["os"] not in oses: continue
        if asset["binary_type"] not in types: continue
        if asset["openjdk_impl"] not in impls: continue
        if asset["heap_size"] != "normal": continue
        if asset["architecture"] not in arch_to_nixos: continue

        version, build = None, None
        # examples: 11.0.1+13, 8.0.222+10
        if asset["version_data"].get("semver") != None:
            version, build = asset["version_data"]["semver"].split("+")
        else:
            version = asset["version_data"]["openjdk_version"]

        type_map = out.setdefault(asset["os"], {})
        impl_map = type_map.setdefault(asset["binary_type"], {})
        arch_map = impl_map.setdefault(asset["openjdk_impl"], {
            "packageType": asset["binary_type"],
            "vmType": asset["openjdk_impl"],
        })

        for nixos_arch in arch_to_nixos[asset["architecture"]]:
            arch_map[nixos_arch] = {
                "url": asset["binary_link"],
                "sha256": get_sha256(asset["checksum_link"]),
                "version": version,
                "build": build,
            }

    return out

out = {}

def request(builds, type):
    for build in builds:
        url = "https://api.adoptopenjdk.net/v2/latestAssets/{}/{}".format(type, build)
        print("GET {}".format(url))
        resp = requests.get(url)
        if resp.status_code != 200:
            print("error: could not fetch data for {} {}:\n{}".format(type, build, resp), file=sys.stderr)
            sys.exit(1)
        if type == 'nightly':
          build += "-{}".format(type)
        out[build] = generate_sources(build, resp.json())

request(releases, "releases")
#request(nightlys, "nightly")

with open("sources.json", "w") as f:
    json.dump(out, f, indent=2, sort_keys=True)
