#!/usr/bin/env python
import sys

from setuptools import find_packages, setup

assert sys.version_info >= (3, 6, 0), "nur requires Python 3.6+"

setup(
    name="nur",
    version="0.0.1",
    description="Tooling to maintain NUR",
    author="Jörg Thalheim",
    author_email="joerg@thalheim.io",
    url="https://github.com/nix-community/nur",
    license="MIT",
    packages=find_packages(),
    entry_points={"console_scripts": ["nur = nur:main"]},
    extras_require={
        "dev": ["mypy", "flake8", "black"],
    },
    classifiers=[
        "Development Status :: 5 - Production/Stable",
        "Environment :: Console",
        "Topic :: Utilities",
        "Intended Audience :: Developers",
        "Programming Language :: Python :: 3.6",
    ],
)
