import argparse
import logging
import sys
from typing import List
import importlib


# the path module does not use logging
# all other modules use logging, so we import them
# after we set the log level with logging.basicConfig
from .path import ROOT_PATH


LOG_LEVELS = dict(
    debug=logging.DEBUG,
    info=logging.INFO,
    error=logging.ERROR,
    critical=logging.CRITICAL,
)


def parse_arguments(argv: List[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        prog=argv[0], description="nur management commands"
    )
    parser.add_argument(
        "--log-level", type=str, default="debug", choices=list(LOG_LEVELS.keys())
    )

    subparsers = parser.add_subparsers(description="subcommands")

    combine = subparsers.add_parser("combine")
    combine.add_argument("directory")
    combine.set_defaults(subcommand="combine")

    format_manifest = subparsers.add_parser("format-manifest")
    format_manifest.set_defaults(subcommand="format_manifest")

    update = subparsers.add_parser("update")
    update.set_defaults(subcommand="update")

    index = subparsers.add_parser("index")
    index.add_argument("directory", default=ROOT_PATH)
    index.set_defaults(subcommand="index")

    args = parser.parse_args(argv[1:])

    if not hasattr(args, "subcommand"):
        print("subcommand is missing", file=sys.stderr)
        parser.print_help(sys.stderr)
        sys.exit(1)

    return args


def main() -> None:
    args = parse_arguments(sys.argv)
    logging.basicConfig(level=LOG_LEVELS[args.log_level])

    cmd = args.subcommand
    module = importlib.import_module('nur.'+ cmd)
    func = getattr(module, f"{cmd}_command")
    return func(args)


if __name__ == "__main__":
    main()
