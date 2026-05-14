#!/usr/bin/env python3
"""Update README.md with packages from flake.nix and default.nix"""

import re
from pathlib import Path


def extract_packages_from_nix(file_path):
    """Extract package names from a nix file, ignoring commented out lines."""
    content = Path(file_path).read_text()
    packages = set()

    # We need to parse differently for flake.nix vs default.nix
    # For flake.nix, only look inside the packages = { ... } rec set
    # For default.nix, look at the main rec set
    if 'flake.nix' in str(file_path):
        # Find the packages.rec block in flake.nix - more permissive pattern
        match = re.search(r'packages = forAllSystems.*?in\s*rec\s*\{(.*?)\}\s*;', content, re.DOTALL)
        if match:
            content = match.group(1)
        else:
            # Try an alternative pattern
            match = re.search(r'pkgs-chaotic =.*?;\s*(.*?)\s*\}\s*;', content, re.DOTALL)
            if match:
                content = match.group(1)
    else:
        # For default.nix, find the main rec block after the special attributes
        match = re.search(r'rec\s*\{(.*)', content, re.DOTALL)
        if match:
            content = match.group(1)

    # Look for package definitions that are actual packages
    # Patterns that indicate a package:
    # - pkgs.callPackage
    # - pkgs*.callPackage
    # - pkgs.*.wrapper
    # - pkgs*.override
    lines = content.split('\n')
    in_comment = False
    for line in lines:
        line_stripped = line.strip()

        # Handle multi-line comments
        if '/*' in line_stripped:
            in_comment = True
        if '*/' in line_stripped:
            in_comment = False
            continue
        if in_comment:
            continue

        # Skip single-line comments
        if line_stripped.startswith('#'):
            continue

        # Match package definitions
        # Look for lines like "  name = pkgs.callPackage ..."
        match = re.match(r'^\s*([a-zA-Z0-9_-]+)\s*=\s*([^#]+)', line)
        if match:
            pkg_name = match.group(1)
            pkg_value = match.group(2)

            # Skip special attributes
            if pkg_name in ['lib', 'modules', 'overlays', 'sources', 'rec', 'buildtools']:
                continue

            # Check if this looks like a package definition
            is_package = any([
                'callPackage' in pkg_value,
                'override' in pkg_value,
                '.wrapper' in pkg_value,
                'pkgs.callPackage' in pkg_value,
                'pkgs-stable.callPackage' in pkg_value,
                'pkgs-yuzu.qt6.callPackage' in pkg_value,
                'pkgs.libsForQt5.callPackage' in pkg_value,
                'pkgs.nerd-fonts' in pkg_value,
                'pkgs.mpv-unwrapped' in pkg_value,
                'pkgs.llama-cpp' in pkg_value,
                'pkgs.koboldcpp' in pkg_value,
                'inputs.chaotic' in pkg_value,
            ])

            # Also add known package directories
            known_packages = [
                'cider', 'hydrogen-music', 'feishu', 'wechat', 'cider3',
                'ttf-ms-win10', 'BBDown', 'reflac',
            ]
            if pkg_name in known_packages:
                is_package = True

            if is_package:
                packages.add(pkg_name)

    return packages


def main():
    repo_root = Path(__file__).parent

    # Extract packages from both files
    flake_pkgs = extract_packages_from_nix(repo_root / 'flake.nix')
    default_pkgs = extract_packages_from_nix(repo_root / 'default.nix')

    # Combine and sort
    all_packages = sorted(flake_pkgs.union(default_pkgs))

    # Read current README
    readme_path = repo_root / 'README.md'
    readme_content = readme_path.read_text()

    # Find the Packages section and replace it
    packages_header = '### Packages'
    before_packages = readme_content.split(packages_header)[0]

    # Keep special package descriptions from original README
    special_descriptions = {
        'HDiffPatch': 'HDiffPatch (required by dawn upgrade scripts for Genshin Impact)',
        'mpv': 'mpv with cdda support',
        'cider': 'Cider 2.3.0 Unfree',
        'hydrogen-music': 'Hydrogen Music',
    }

    # Skip list for internal/cache packages
    skip_packages = {
        'buildtools',
        'mongodb',
        'cudatoolkit',
        'misskey',
        'JetBrainsMono-nerdfonts',
        'linux_cachyos-lto-x86_64-v3',
    }

    # Generate new package list
    new_package_list = []
    for pkg in all_packages:
        if pkg in skip_packages:
            continue
        if pkg in special_descriptions:
            new_package_list.append(f'* {special_descriptions[pkg]}')
        else:
            new_package_list.append(f'* {pkg}')

    # Build new README
    new_readme = (
        before_packages.rstrip()
        + '\n\n'
        + packages_header
        + '\n\n'
        + '\n'.join(new_package_list)
        + '\n'
    )

    # Write back
    readme_path.write_text(new_readme)
    print(f"Updated README.md with {len(new_package_list)} packages")


if __name__ == '__main__':
    main()
