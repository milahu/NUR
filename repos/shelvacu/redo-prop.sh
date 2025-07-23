#!/usr/bin/env bash
set -xeuo pipefail
nix build .#qb.prop
scp result/etc/fstab 10.78.79.22:new-fstab
scp result/etc/mdadm.conf 10.78.79.22:new-mdadm.conf
ssh 10.78.79.22 git clone https://git.uninsane.org/shelvacu/nix-stuff
ssh 10.78.79.22 sudo mdadm --manage --stop /dev/md127
ssh 10.78.79.22 sudo mdadm -A --config=new-mdadm.conf --verbose --scan
ssh -t 10.78.79.22 sudo cryptsetup open /dev/disk/by-uuid/98cec659-ed09-4e51-bc44-c6264dc680ed prophecy-root-decrypted
ssh 10.78.79.22 sed -i "'s: /: /mnt/:'" new-fstab
ssh 10.78.79.22 sudo mount --fstab new-fstab --all --verbose || true
ssh 10.78.79.22 sudo nixos-install --flake ./nix-stuff#prophecy --no-root-password
