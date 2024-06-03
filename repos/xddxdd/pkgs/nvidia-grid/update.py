import functools
import json
import os
import re
import subprocess
import sys
from typing import List, Optional, Tuple

import requests

REPO = "Crystalast029/nv-vgpu-driver-archive"


def get_script_path():
    return os.path.dirname(os.path.realpath(sys.argv[0]))


def get_download_link_for_version(
    version: str,
) -> Tuple[List[str], List[str], Optional[str], Optional[str]]:
    try:
        print(f"Checking version {version}")
        data: requests.Response = requests.get(
            f"https://foxi.buduanwang.vip/pan/vGPU/{version}/"
        )
        match = re.search(
            r'href="(NVIDIA-GRID-Linux-KVM-([^-]+)(-([^-]+))?-([^-]+)\.([^"\']+))"',
            data.text,
            re.MULTILINE | re.IGNORECASE,
        )
        filename = match[1]
        host_version = match[2]
        guest_version = match[3]
        guest_version = guest_version[1:] if guest_version else host_version
        print(filename, host_version, guest_version)
        url = f"https://foxi.buduanwang.vip/pan/vGPU/{version}/{filename}"

        patches = re.findall(
            r'href="([^"\']+\.patch)"',
            data.text,
            re.MULTILINE | re.IGNORECASE,
        )
        patches = [
            f"https://foxi.buduanwang.vip/pan/vGPU/{version}/{filename}"
            for filename in patches
        ]
        print("Patches:", patches)

        return url, patches, host_version, guest_version
    except Exception:
        return [], [], None, None


def get_available_versions() -> List[str]:
    data = requests.get("https://foxi.buduanwang.vip/pan/vGPU/")
    return re.findall(r'href="([0-9\.]+)/"', data.text, re.MULTILINE | re.IGNORECASE)


@functools.lru_cache(maxsize=None)
def nix_prefetch_url(url: str):
    result = subprocess.run(["nix-prefetch-url", url], stdout=subprocess.PIPE)
    if result.returncode != 0:
        raise RuntimeError(f"nix-prefetch-url exited with error {result.returncode}")
    return result.stdout.decode("utf-8").strip()


@functools.lru_cache(maxsize=None)
def nix_prefetch_git(url: str, rev: str):
    result = subprocess.run(
        ["nix-prefetch-git", "--url", url, "--rev", rev], stdout=subprocess.PIPE
    )
    if result.returncode != 0:
        raise RuntimeError(f"nix-prefetch-git exited with error {result.returncode}")
    result = json.loads(result.stdout.decode("utf-8").strip())
    return result["hash"]


NvidiaVersion = Tuple[int, int, int, str]


def parse_nvidia_version(version: str) -> NvidiaVersion:
    splitted = [int(i) for i in re.split(r"[^0-9]+", version)]
    return (
        splitted[0] if len(splitted) >= 1 else 0,
        splitted[1] if len(splitted) >= 2 else 0,
        splitted[2] if len(splitted) >= 3 else 0,
        # Store original version last for converting back
        version,
    )


def get_nvidia_persistenced_versions() -> List[NvidiaVersion]:
    token = os.getenv("GITHUB_TOKEN")
    data = requests.get(
        "https://api.github.com/repos/NVIDIA/nvidia-persistenced/git/refs/tags",
        headers={
            **({"Authorization": f"Bearer {token}"} if token else {}),
        },
    ).json()
    return sorted([parse_nvidia_version(d["ref"][len("refs/tags/") :]) for d in data])


nvidia_persistenced_versions = get_nvidia_persistenced_versions()


def get_nvidia_settings_versions() -> List[NvidiaVersion]:
    token = os.getenv("GITHUB_TOKEN")
    data = requests.get(
        "https://api.github.com/repos/NVIDIA/nvidia-settings/git/refs/tags",
        headers={
            **({"Authorization": f"Bearer {token}"} if token else {}),
        },
    ).json()
    return sorted([parse_nvidia_version(d["ref"][len("refs/tags/") :]) for d in data])


nvidia_settings_versions = get_nvidia_settings_versions()


def match_latest_version_str(
    available: List[NvidiaVersion], target: NvidiaVersion
) -> Optional[NvidiaVersion]:
    versions = sorted(list(filter(lambda v: v <= target, available)))
    return versions[-1][3] if len(versions) else None


# Load existing records
try:
    with open(get_script_path() + "/sources.json") as f:
        result = json.load(f)
except Exception:
    result = {}

for version in get_available_versions():
    if version not in result.keys():
        download_link, patches, host_version, guest_version = (
            get_download_link_for_version(version)
        )
        if not download_link:
            continue
        urls = [download_link]

        # hash = nix_prefetch_url(url)
        host_persistenced_version = match_latest_version_str(
            nvidia_persistenced_versions, parse_nvidia_version(host_version)
        )
        host_settings_version = match_latest_version_str(
            nvidia_settings_versions, parse_nvidia_version(host_version)
        )
        guest_persistenced_version = match_latest_version_str(
            nvidia_persistenced_versions, parse_nvidia_version(guest_version)
        )
        guest_settings_version = match_latest_version_str(
            nvidia_settings_versions, parse_nvidia_version(guest_version)
        )
        result[version] = {
            "urls": {url: nix_prefetch_url(url) for url in urls},
            "patches": {url: nix_prefetch_url(url) for url in patches},
            "host": {
                "version": host_version,
                "persistenced_version": host_persistenced_version,
                "persistenced_hash": nix_prefetch_git(
                    "https://github.com/NVIDIA/nvidia-persistenced.git",
                    host_persistenced_version,
                ),
                "settings_version": host_settings_version,
                "settings_hash": nix_prefetch_git(
                    "https://github.com/NVIDIA/nvidia-settings.git",
                    host_settings_version,
                ),
            },
            "guest": {
                "version": guest_version,
                "persistenced_version": guest_persistenced_version,
                "persistenced_hash": nix_prefetch_git(
                    "https://github.com/NVIDIA/nvidia-persistenced.git",
                    guest_persistenced_version,
                ),
                "settings_version": guest_settings_version,
                "settings_hash": nix_prefetch_git(
                    "https://github.com/NVIDIA/nvidia-settings.git",
                    guest_settings_version,
                ),
            },
        }

        # Write as json on every update to retain data on interruption
        with open(get_script_path() + "/sources.json", "w") as f:
            f.write(json.dumps(result, indent=4))
