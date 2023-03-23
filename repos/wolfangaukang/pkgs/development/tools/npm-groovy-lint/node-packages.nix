# This file has been generated by node2nix 1.11.1. Do not edit!

{nodeEnv, fetchurl, fetchgit, nix-gitignore, stdenv, lib, globalBuildInputs ? []}:

let
  sources = {
    "@types/sarif-2.1.4" = {
      name = "_at_types_slash_sarif";
      packageName = "@types/sarif";
      version = "2.1.4";
      src = fetchurl {
        url = "https://registry.npmjs.org/@types/sarif/-/sarif-2.1.4.tgz";
        sha512 = "4xKHMdg3foh3Va1fxTzY1qt8QVqmaJpGWsVvtjQrJBn+/bkig2pWFKJ4FPI2yLI4PAj0SUKiPO4Vd7ggYIMZjQ==";
      };
    };
    "amplitude-5.2.0" = {
      name = "amplitude";
      packageName = "amplitude";
      version = "5.2.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/amplitude/-/amplitude-5.2.0.tgz";
        sha512 = "lr1hpTh0GBk9dEIW1gkeBcBvPQtp3O6Y+ynhpEPc8MoW2+yw6rJt4HQRxN5QFJGvO/41QaYeFXjoGyxXrgfgsw==";
      };
    };
    "ansi-colors-4.1.3" = {
      name = "ansi-colors";
      packageName = "ansi-colors";
      version = "4.1.3";
      src = fetchurl {
        url = "https://registry.npmjs.org/ansi-colors/-/ansi-colors-4.1.3.tgz";
        sha512 = "/6w/C21Pm1A7aZitlI5Ni/2J6FFQN8i1Cvz3kHABAAbw93v/NlvKdVOqz7CCWz/3iv/JplRSEEZ83XION15ovw==";
      };
    };
    "ansi-regex-5.0.1" = {
      name = "ansi-regex";
      packageName = "ansi-regex";
      version = "5.0.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz";
        sha512 = "quJQXlTSUGL2LH9SUXo8VwsY4soanhgo6LNSm84E1LBcE8s3O0wpdiRzyR9z/ZZJMlMWv37qOOb9pdJlMUEKFQ==";
      };
    };
    "ansi-styles-4.3.0" = {
      name = "ansi-styles";
      packageName = "ansi-styles";
      version = "4.3.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz";
        sha512 = "zbB9rCJAT1rbjiVDb2hqKFHNYLxgtk8NURxZ3IZwD3F6NtxbXZQCnnSi1Lkx+IDohdPlFp222wVALIheZJQSEg==";
      };
    };
    "argparse-2.0.1" = {
      name = "argparse";
      packageName = "argparse";
      version = "2.0.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/argparse/-/argparse-2.0.1.tgz";
        sha512 = "8+9WqebbFzpX9OR+Wa6O29asIogeRMzcGtAINdpMHHyAg10f05aSFVBbcEqGf/PXw1EjAZ+q2/bEBg3DvurK3Q==";
      };
    };
    "at-least-node-1.0.0" = {
      name = "at-least-node";
      packageName = "at-least-node";
      version = "1.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/at-least-node/-/at-least-node-1.0.0.tgz";
        sha512 = "+q/t7Ekv1EDY2l6Gda6LLiX14rU9TV20Wa3ofeQmwPFZbOMo9DXrLbOjFaaclkXKWidIaopwAObQDqwWtGUjqg==";
      };
    };
    "axios-0.21.4" = {
      name = "axios";
      packageName = "axios";
      version = "0.21.4";
      src = fetchurl {
        url = "https://registry.npmjs.org/axios/-/axios-0.21.4.tgz";
        sha512 = "ut5vewkiu8jjGBdqpM44XxjuCjq9LAKeHVmoVfHVzy8eHgxxq8SbAVQNovDA8mVi05kP0Ea/n/UzcSHcTJQfNg==";
      };
    };
    "axios-0.24.0" = {
      name = "axios";
      packageName = "axios";
      version = "0.24.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/axios/-/axios-0.24.0.tgz";
        sha512 = "Q6cWsys88HoPgAaFAVUb0WpPk0O8iTeisR9IMqy9G8AbO4NlpVknrnQS03zzF9PGAWgO3cgletO3VjV/P7VztA==";
      };
    };
    "balanced-match-1.0.2" = {
      name = "balanced-match";
      packageName = "balanced-match";
      version = "1.0.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/balanced-match/-/balanced-match-1.0.2.tgz";
        sha512 = "3oSeUO0TMV67hN1AmbXsK4yaqU7tjiHlbxRDZOpH0KW9+CeX4bRAaX0Anxt0tx2MrpRpWwQaPwIlISEJhYU5Pw==";
      };
    };
    "brace-expansion-1.1.11" = {
      name = "brace-expansion";
      packageName = "brace-expansion";
      version = "1.1.11";
      src = fetchurl {
        url = "https://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.11.tgz";
        sha512 = "iCuPHDFgrHX7H2vEI/5xpz07zSHB00TpugqhmYtVmMO6518mCuRMoOYFldEBl0g187ufozdaHgWKcYFb61qGiA==";
      };
    };
    "buffer-crc32-0.2.13" = {
      name = "buffer-crc32";
      packageName = "buffer-crc32";
      version = "0.2.13";
      src = fetchurl {
        url = "https://registry.npmjs.org/buffer-crc32/-/buffer-crc32-0.2.13.tgz";
        sha512 = "VO9Ht/+p3SN7SKWqcrgEzjGbRSJYTx+Q1pTQC0wrWqHx0vpJraQ6GtHx8tvcg1rlK1byhU5gccxgOgj7B0TDkQ==";
      };
    };
    "callsites-3.1.0" = {
      name = "callsites";
      packageName = "callsites";
      version = "3.1.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/callsites/-/callsites-3.1.0.tgz";
        sha512 = "P8BjAsXvZS+VIDUI11hHCQEv74YT67YUi5JJFNWIqL235sBmjX4+qx9Muvls5ivyNENctx46xQLQ3aTuE7ssaQ==";
      };
    };
    "chalk-4.1.2" = {
      name = "chalk";
      packageName = "chalk";
      version = "4.1.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/chalk/-/chalk-4.1.2.tgz";
        sha512 = "oKnbhFyRIXpUuez8iBMmyEa4nbj4IOQyuhc/wy9kY7/WVPcwIO9VA668Pu8RkO7+0G76SLROeyw9CpQ061i4mA==";
      };
    };
    "chownr-1.1.4" = {
      name = "chownr";
      packageName = "chownr";
      version = "1.1.4";
      src = fetchurl {
        url = "https://registry.npmjs.org/chownr/-/chownr-1.1.4.tgz";
        sha512 = "jJ0bqzaylmJtVnNgzTeSOs8DPavpbYgEr/b0YL8/2GO3xJEhInFmhKMUnEJQjZumK7KXGFhUy89PrsJWlakBVg==";
      };
    };
    "cli-progress-3.11.2" = {
      name = "cli-progress";
      packageName = "cli-progress";
      version = "3.11.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/cli-progress/-/cli-progress-3.11.2.tgz";
        sha512 = "lCPoS6ncgX4+rJu5bS3F/iCz17kZ9MPZ6dpuTtI0KXKABkhyXIdYB3Inby1OpaGti3YlI3EeEkM9AuWpelJrVA==";
      };
    };
    "color-convert-2.0.1" = {
      name = "color-convert";
      packageName = "color-convert";
      version = "2.0.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz";
        sha512 = "RRECPsj7iu/xb5oKYcsFHSppFNnsj/52OVTRKb4zP5onXwVF3zVmmToNcOfGC+CRDpfK/U584fMg38ZHCaElKQ==";
      };
    };
    "color-name-1.1.4" = {
      name = "color-name";
      packageName = "color-name";
      version = "1.1.4";
      src = fetchurl {
        url = "https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz";
        sha512 = "dOy+3AuW3a2wNbZHIuMZpTcgjGuLU/uBL/ubcZF9OXbDo8ff4O8yVp5Bf0efS8uEoYo5q4Fx7dY9OgQGXgAsQA==";
      };
    };
    "command-exists-promise-2.0.2" = {
      name = "command-exists-promise";
      packageName = "command-exists-promise";
      version = "2.0.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/command-exists-promise/-/command-exists-promise-2.0.2.tgz";
        sha512 = "T6PB6vdFrwnHXg/I0kivM3DqaCGZLjjYSOe0a5WgFKcz1sOnmOeIjnhQPXVXX3QjVbLyTJ85lJkX6lUpukTzaA==";
      };
    };
    "commondir-1.0.1" = {
      name = "commondir";
      packageName = "commondir";
      version = "1.0.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/commondir/-/commondir-1.0.1.tgz";
        sha512 = "W9pAhw0ja1Edb5GVdIF1mjZw/ASI0AlShXM83UUGe2DVr5TdAPEA1OA8m/g8zWp9x6On7gqufY+FatDbC3MDQg==";
      };
    };
    "concat-map-0.0.1" = {
      name = "concat-map";
      packageName = "concat-map";
      version = "0.0.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/concat-map/-/concat-map-0.0.1.tgz";
        sha512 = "/Srv4dswyQNBfohGpz9o6Yb3Gz3SrUDqBH5rTuhGR7ahtlbYKnVxw2bCFMRljaA7EXHaXZ8wsHdodFvbkhKmqg==";
      };
    };
    "debug-4.3.4" = {
      name = "debug";
      packageName = "debug";
      version = "4.3.4";
      src = fetchurl {
        url = "https://registry.npmjs.org/debug/-/debug-4.3.4.tgz";
        sha512 = "PRWFHuSU3eDtQJPvnNY7Jcket1j0t5OuOsFzPPzsekD52Zl8qUfFIPEiswXqIvHWGVHOgX+7G/vCNNhehwxfkQ==";
      };
    };
    "decode-html-2.0.0" = {
      name = "decode-html";
      packageName = "decode-html";
      version = "2.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/decode-html/-/decode-html-2.0.0.tgz";
        sha512 = "lVJ+EBozhAXA2nSQG+xAgcD0P5K3uejnIIvM09uoQfS8AALkQ+HhHcEUvKovXi0EIpIZWjm0y8X7ULjaJpgY9w==";
      };
    };
    "deep-is-0.1.4" = {
      name = "deep-is";
      packageName = "deep-is";
      version = "0.1.4";
      src = fetchurl {
        url = "https://registry.npmjs.org/deep-is/-/deep-is-0.1.4.tgz";
        sha512 = "oIPzksmTg4/MriiaYGO+okXDT7ztn/w3Eptv/+gSIdMdKsJo0u4CfYNFJPy+4SKMuCqGw2wxnA+URMg3t8a/bQ==";
      };
    };
    "emoji-regex-8.0.0" = {
      name = "emoji-regex";
      packageName = "emoji-regex";
      version = "8.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/emoji-regex/-/emoji-regex-8.0.0.tgz";
        sha512 = "MSjYzcWNOA0ewAHpz0MxpYFvwg6yjy1NG3xteoqz644VCo/RPgnr1/GGt+ic3iJTzQ8Eu3TdM14SawnVUmGE6A==";
      };
    };
    "fast-levenshtein-2.0.6" = {
      name = "fast-levenshtein";
      packageName = "fast-levenshtein";
      version = "2.0.6";
      src = fetchurl {
        url = "https://registry.npmjs.org/fast-levenshtein/-/fast-levenshtein-2.0.6.tgz";
        sha512 = "DCXu6Ifhqcks7TZKY3Hxp3y6qphY5SJZmrWMDrKcERSOXWQdMhU9Ig/PYrzyw/ul9jOIyh0N4M0tbC5hodg8dw==";
      };
    };
    "fd-slicer-1.1.0" = {
      name = "fd-slicer";
      packageName = "fd-slicer";
      version = "1.1.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/fd-slicer/-/fd-slicer-1.1.0.tgz";
        sha512 = "cE1qsB/VwyQozZ+q1dGxR8LBYNZeofhEdUNGSMbQD3Gw2lAzX9Zb3uIU6Ebc/Fmyjo9AWWfnn0AUCHqtevs/8g==";
      };
    };
    "find-java-home-1.2.2" = {
      name = "find-java-home";
      packageName = "find-java-home";
      version = "1.2.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/find-java-home/-/find-java-home-1.2.2.tgz";
        sha512 = "rN2LcQa+YDwfnPT0TQgn015eYqJkn3h3G/uVX5oOD2Ge7gKOuoJrntAJO4BiGb+K6lo6Mb+xJdoqbfzqaC75gw==";
      };
    };
    "find-package-json-1.2.0" = {
      name = "find-package-json";
      packageName = "find-package-json";
      version = "1.2.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/find-package-json/-/find-package-json-1.2.0.tgz";
        sha512 = "+SOGcLGYDJHtyqHd87ysBhmaeQ95oWspDKnMXBrnQ9Eq4OkLNqejgoaD8xVWu6GPa0B6roa6KinCMEMcVeqONw==";
      };
    };
    "follow-redirects-1.15.1" = {
      name = "follow-redirects";
      packageName = "follow-redirects";
      version = "1.15.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/follow-redirects/-/follow-redirects-1.15.1.tgz";
        sha512 = "yLAMQs+k0b2m7cVxpS1VKJVvoz7SS9Td1zss3XRwXj+ZDH00RJgnuLx7E44wx02kQLrdM3aOOy+FpzS7+8OizA==";
      };
    };
    "fs-extra-10.1.0" = {
      name = "fs-extra";
      packageName = "fs-extra";
      version = "10.1.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/fs-extra/-/fs-extra-10.1.0.tgz";
        sha512 = "oRXApq54ETRj4eMiFzGnHWGy+zo5raudjuxN0b8H7s/RU2oW0Wvsx9O0ACRN/kRq9E8Vu/ReskGB5o3ji+FzHQ==";
      };
    };
    "fs-extra-8.1.0" = {
      name = "fs-extra";
      packageName = "fs-extra";
      version = "8.1.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/fs-extra/-/fs-extra-8.1.0.tgz";
        sha512 = "yhlQgA6mnOJUKOsRUFsgJdQCvkKhcz8tlZG5HBQfReYZy46OwLcY+Zia0mtdHsOo9y/hP+CxMN0TU9QxoOtG4g==";
      };
    };
    "fs-extra-9.1.0" = {
      name = "fs-extra";
      packageName = "fs-extra";
      version = "9.1.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/fs-extra/-/fs-extra-9.1.0.tgz";
        sha512 = "hcg3ZmepS30/7BSFqRvoo3DOMQu7IjqxO5nCDt+zM9XWjb33Wg7ziNT+Qvqbuc3+gWpzO02JubVyk2G4Zvo1OQ==";
      };
    };
    "fs-minipass-1.2.7" = {
      name = "fs-minipass";
      packageName = "fs-minipass";
      version = "1.2.7";
      src = fetchurl {
        url = "https://registry.npmjs.org/fs-minipass/-/fs-minipass-1.2.7.tgz";
        sha512 = "GWSSJGFy4e9GUeCcbIkED+bgAoFyj7XF1mV8rma3QW4NIqX9Kyx79N/PF61H5udOV3aY1IaMLs6pGbH71nlCTA==";
      };
    };
    "fs.realpath-1.0.0" = {
      name = "fs.realpath";
      packageName = "fs.realpath";
      version = "1.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/fs.realpath/-/fs.realpath-1.0.0.tgz";
        sha512 = "OO0pH2lK6a0hZnAdau5ItzHPI6pUlvI7jMVnxUQRtw4owF2wk8lOSabtGDCTP4Ggrg2MbGnWO9X8K1t4+fGMDw==";
      };
    };
    "glob-7.2.3" = {
      name = "glob";
      packageName = "glob";
      version = "7.2.3";
      src = fetchurl {
        url = "https://registry.npmjs.org/glob/-/glob-7.2.3.tgz";
        sha512 = "nFR0zLpU2YCaRxwoCJvL6UvCH2JFyFVIvwTLsIf21AuHlMskA1hhTdk+LlYJtOlYt9v6dvszD2BGRqBL+iQK9Q==";
      };
    };
    "graceful-fs-4.2.10" = {
      name = "graceful-fs";
      packageName = "graceful-fs";
      version = "4.2.10";
      src = fetchurl {
        url = "https://registry.npmjs.org/graceful-fs/-/graceful-fs-4.2.10.tgz";
        sha512 = "9ByhssR2fPVsNZj478qUUbKfmL0+t5BDVyjShtyZZLiK7ZDAArFFfopyOTj0M05wE2tJPisA4iTnnXl2YoPvOA==";
      };
    };
    "has-flag-4.0.0" = {
      name = "has-flag";
      packageName = "has-flag";
      version = "4.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/has-flag/-/has-flag-4.0.0.tgz";
        sha512 = "EykJT/Q1KjTWctppgIAgfSO0tKVuZUjhgMr17kqTumMl6Afv3EISleU7qZUzoXDFTAHTDC4NOoG/ZxU3EvlMPQ==";
      };
    };
    "import-fresh-3.3.0" = {
      name = "import-fresh";
      packageName = "import-fresh";
      version = "3.3.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/import-fresh/-/import-fresh-3.3.0.tgz";
        sha512 = "veYYhQa+D1QBKznvhUHxb8faxlrwUnxseDAbAp457E0wLNio2bOSKnjYDhMj+YiAq61xrMGhQk9iXVk5FzgQMw==";
      };
    };
    "inflight-1.0.6" = {
      name = "inflight";
      packageName = "inflight";
      version = "1.0.6";
      src = fetchurl {
        url = "https://registry.npmjs.org/inflight/-/inflight-1.0.6.tgz";
        sha512 = "k92I/b08q4wvFscXCLvqfsHCrjrF7yiXsQuIVvVE7N82W3+aqpzuUdBbfhWcy/FZR3/4IgflMgKLOsvPDrGCJA==";
      };
    };
    "inherits-2.0.4" = {
      name = "inherits";
      packageName = "inherits";
      version = "2.0.4";
      src = fetchurl {
        url = "https://registry.npmjs.org/inherits/-/inherits-2.0.4.tgz";
        sha512 = "k/vGaX4/Yla3WzyMCvTQOXYeIHvqOKtnqBduzTHpzpQZzAskKMhZ2K+EnBiSM9zGSoIFeMpXKxa4dYeZIQqewQ==";
      };
    };
    "ip-1.1.8" = {
      name = "ip";
      packageName = "ip";
      version = "1.1.8";
      src = fetchurl {
        url = "https://registry.npmjs.org/ip/-/ip-1.1.8.tgz";
        sha512 = "PuExPYUiu6qMBQb4l06ecm6T6ujzhmh+MeJcW9wa89PoAz5pvd4zPgN5WJV104mb6S2T1AwNIAaB70JNrLQWhg==";
      };
    };
    "is-fullwidth-code-point-3.0.0" = {
      name = "is-fullwidth-code-point";
      packageName = "is-fullwidth-code-point";
      version = "3.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-3.0.0.tgz";
        sha512 = "zymm5+u+sCsSWyD9qNaejV3DFvhCKclKdizYaJUuHA83RLjb7nSuGnddCHGv0hk+KY7BMAlsWeK4Ueg6EV6XQg==";
      };
    };
    "java-caller-2.4.0" = {
      name = "java-caller";
      packageName = "java-caller";
      version = "2.4.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/java-caller/-/java-caller-2.4.0.tgz";
        sha512 = "xDf1AIyo2CN5rWZ1NeNMJkfDmq/zXIDq2ley7UcgL7l2ebWGwTPduTWom6kg6m/8IsF+qChoxJYTXE8N0aj5rQ==";
      };
    };
    "js-yaml-4.1.0" = {
      name = "js-yaml";
      packageName = "js-yaml";
      version = "4.1.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/js-yaml/-/js-yaml-4.1.0.tgz";
        sha512 = "wpxZs9NoxZaJESJGIZTyDEaYpl0FKSA+FB9aJiyemKhMwkxQg63h4T1KJgUGHpTqPDNRcmmYLugrRjJlBtWvRA==";
      };
    };
    "jsonfile-4.0.0" = {
      name = "jsonfile";
      packageName = "jsonfile";
      version = "4.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/jsonfile/-/jsonfile-4.0.0.tgz";
        sha512 = "m6F1R3z8jjlf2imQHS2Qez5sjKWQzbuuhuJ/FKYFRZvPE3PuHcSMVZzfsLhGVOkfd20obL5SWEBew5ShlquNxg==";
      };
    };
    "jsonfile-6.1.0" = {
      name = "jsonfile";
      packageName = "jsonfile";
      version = "6.1.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/jsonfile/-/jsonfile-6.1.0.tgz";
        sha512 = "5dgndWOriYSm5cnYaJNhalLNDKOqFwyDB/rr1E9ZsGciGvKPs8R2xYGCacuf3z6K1YKDz182fd+fY3cn3pMqXQ==";
      };
    };
    "levn-0.3.0" = {
      name = "levn";
      packageName = "levn";
      version = "0.3.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/levn/-/levn-0.3.0.tgz";
        sha512 = "0OO4y2iOHix2W6ujICbKIaEQXvFQHue65vUG3pb5EUomzPI90z9hsA1VsO/dbIIpC53J8gxM9Q4Oho0jrCM/yA==";
      };
    };
    "lru-cache-6.0.0" = {
      name = "lru-cache";
      packageName = "lru-cache";
      version = "6.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/lru-cache/-/lru-cache-6.0.0.tgz";
        sha512 = "Jo6dJ04CmSjuznwJSS3pUeWmd/H0ffTlkXXgwZi+eq1UCmqQwCh+eLsYOYCwY991i2Fah4h1BEMCx4qThGbsiA==";
      };
    };
    "minimatch-3.1.2" = {
      name = "minimatch";
      packageName = "minimatch";
      version = "3.1.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/minimatch/-/minimatch-3.1.2.tgz";
        sha512 = "J7p63hRiAjw1NDEww1W7i37+ByIrOWO5XQQAzZ3VOcL0PNybwpfmV/N05zFAzwQ9USyEcX6t3UO+K5aqBQOIHw==";
      };
    };
    "minimist-1.2.6" = {
      name = "minimist";
      packageName = "minimist";
      version = "1.2.6";
      src = fetchurl {
        url = "https://registry.npmjs.org/minimist/-/minimist-1.2.6.tgz";
        sha512 = "Jsjnk4bw3YJqYzbdyBiNsPWHPfO++UGG749Cxs6peCu5Xg4nrena6OVxOYxrQTqww0Jmwt+Ref8rggumkTLz9Q==";
      };
    };
    "minipass-2.9.0" = {
      name = "minipass";
      packageName = "minipass";
      version = "2.9.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/minipass/-/minipass-2.9.0.tgz";
        sha512 = "wxfUjg9WebH+CUDX/CdbRlh5SmfZiy/hpkxaRI16Y9W56Pa75sWgd/rvFilSgrauD9NyFymP/+JFV3KwzIsJeg==";
      };
    };
    "minizlib-1.3.3" = {
      name = "minizlib";
      packageName = "minizlib";
      version = "1.3.3";
      src = fetchurl {
        url = "https://registry.npmjs.org/minizlib/-/minizlib-1.3.3.tgz";
        sha512 = "6ZYMOEnmVsdCeTJVE0W9ZD+pVnE8h9Hma/iOwwRDsdQoePpoX56/8B6z3P9VNwppJuBKNRuFDRNRqRWexT9G9Q==";
      };
    };
    "mkdirp-0.5.5" = {
      name = "mkdirp";
      packageName = "mkdirp";
      version = "0.5.5";
      src = fetchurl {
        url = "https://registry.npmjs.org/mkdirp/-/mkdirp-0.5.5.tgz";
        sha512 = "NKmAlESf6jMGym1++R0Ra7wvhV+wFW63FaSOFPwRahvea0gMUcGUhVeAg/0BC0wiv9ih5NYPB1Wn1UEI1/L+xQ==";
      };
    };
    "ms-2.1.2" = {
      name = "ms";
      packageName = "ms";
      version = "2.1.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/ms/-/ms-2.1.2.tgz";
        sha512 = "sGkPx+VjMtmA6MX27oA4FBFELFCZZ4S4XqeGOXCv68tT+jb3vk/RyaKWP0PTKyWtmLSM0b+adUTEvbs1PEaH2w==";
      };
    };
    "njre-0.2.0" = {
      name = "njre";
      packageName = "njre";
      version = "0.2.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/njre/-/njre-0.2.0.tgz";
        sha512 = "+Wq8R6VmjK+jI8a9NdzfU6Vh50r3tjsdvl5KJE1OyHeH8I/nx5Ptm12qpO3qNUbstXuZfBDgDL0qQZw9JyjhMw==";
      };
    };
    "node-fetch-2.6.7" = {
      name = "node-fetch";
      packageName = "node-fetch";
      version = "2.6.7";
      src = fetchurl {
        url = "https://registry.npmjs.org/node-fetch/-/node-fetch-2.6.7.tgz";
        sha512 = "ZjMPFEfVx5j+y2yF35Kzx5sF7kDzxuDj6ziH4FFbOp87zKDZNx8yExJIb05OGF4Nlt9IHFIMBkRl41VdvcNdbQ==";
      };
    };
    "node-sarif-builder-2.0.2" = {
      name = "node-sarif-builder";
      packageName = "node-sarif-builder";
      version = "2.0.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/node-sarif-builder/-/node-sarif-builder-2.0.2.tgz";
        sha512 = "SkNE1BnGyO5FdHscmGQ0cQ/9S1nHt+vi+UHr5AGbzVaeeTzZBHnpDoi5XIB3Cj7KtzI3kxocKkI6HLdTBcRNLA==";
      };
    };
    "once-1.4.0" = {
      name = "once";
      packageName = "once";
      version = "1.4.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/once/-/once-1.4.0.tgz";
        sha512 = "lNaJgI+2Q5URQBkccEKHTQOPaXdUxnZZElQTZY0MFUAuaEqe1E+Nyvgdz/aIyNi6Z9MzO5dv1H8n58/GELp3+w==";
      };
    };
    "optionator-0.8.3" = {
      name = "optionator";
      packageName = "optionator";
      version = "0.8.3";
      src = fetchurl {
        url = "https://registry.npmjs.org/optionator/-/optionator-0.8.3.tgz";
        sha512 = "+IW9pACdk3XWmmTXG8m3upGUJst5XRGzxMRjXzAuJ1XnIFNvfhjjIuYkDvysnPQ7qzqVzLt78BCruntqRhWQbA==";
      };
    };
    "parent-module-1.0.1" = {
      name = "parent-module";
      packageName = "parent-module";
      version = "1.0.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/parent-module/-/parent-module-1.0.1.tgz";
        sha512 = "GQ2EWRpQV8/o+Aw8YqtfZZPfNRWZYkbidE9k5rpl/hC3vtHHBfGm2Ifi6qWV+coDGkrUKZAxE3Lot5kcsRlh+g==";
      };
    };
    "path-is-absolute-1.0.1" = {
      name = "path-is-absolute";
      packageName = "path-is-absolute";
      version = "1.0.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/path-is-absolute/-/path-is-absolute-1.0.1.tgz";
        sha512 = "AVbw3UJ2e9bq64vSaS9Am0fje1Pa8pbGqTTsmXfaIiMpnr5DlDhfJOuLj9Sf95ZPVDAUerDfEk88MPmPe7UCQg==";
      };
    };
    "pend-1.2.0" = {
      name = "pend";
      packageName = "pend";
      version = "1.2.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/pend/-/pend-1.2.0.tgz";
        sha512 = "F3asv42UuXchdzt+xXqfW1OGlVBe+mxa2mqI0pg5yAHZPvFmY3Y6drSf/GQ1A86WgWEN9Kzh/WrgKa6iGcHXLg==";
      };
    };
    "prelude-ls-1.1.2" = {
      name = "prelude-ls";
      packageName = "prelude-ls";
      version = "1.1.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/prelude-ls/-/prelude-ls-1.1.2.tgz";
        sha512 = "ESF23V4SKG6lVSGZgYNpbsiaAkdab6ZgOxe52p7+Kid3W3u3bxR4Vfd/o21dmN7jSt0IwgZ4v5MUd26FEtXE9w==";
      };
    };
    "resolve-from-4.0.0" = {
      name = "resolve-from";
      packageName = "resolve-from";
      version = "4.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/resolve-from/-/resolve-from-4.0.0.tgz";
        sha512 = "pb/MYmXstAkysRFx8piNI1tGFNQIFA3vkE3Gq4EuA1dF6gHp/+vgZqsCGJapvy8N3Q+4o7FwvquPJcnZ7RYy4g==";
      };
    };
    "safe-buffer-5.1.2" = {
      name = "safe-buffer";
      packageName = "safe-buffer";
      version = "5.1.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.1.2.tgz";
        sha512 = "Gd2UZBJDkXlY7GbJxfsE8/nvKkUEU1G38c1siN6QP6a9PT9MmHB8GnpscSmMJSoF8LOIrt8ud/wPtojys4G6+g==";
      };
    };
    "safe-buffer-5.2.1" = {
      name = "safe-buffer";
      packageName = "safe-buffer";
      version = "5.2.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.2.1.tgz";
        sha512 = "rp3So07KcdmmKbGvgaNxQSJr7bGVSVk5S9Eq1F+ppbRo70+YeaDxkw5Dd8NPN+GD6bjnYm2VuPuCXmpuYvmCXQ==";
      };
    };
    "semver-7.3.7" = {
      name = "semver";
      packageName = "semver";
      version = "7.3.7";
      src = fetchurl {
        url = "https://registry.npmjs.org/semver/-/semver-7.3.7.tgz";
        sha512 = "QlYTucUYOews+WeEujDoEGziz4K6c47V/Bd+LjSSYcA94p+DmINdf7ncaUinThfvZyu13lN9OY1XDxt8C0Tw0g==";
      };
    };
    "string-width-4.2.3" = {
      name = "string-width";
      packageName = "string-width";
      version = "4.2.3";
      src = fetchurl {
        url = "https://registry.npmjs.org/string-width/-/string-width-4.2.3.tgz";
        sha512 = "wKyQRQpjJ0sIp62ErSZdGsjMJWsap5oRNihHhu6G7JVO/9jIB6UyevL+tXuOqrng8j/cxKTWyWUwvSTriiZz/g==";
      };
    };
    "strip-ansi-6.0.1" = {
      name = "strip-ansi";
      packageName = "strip-ansi";
      version = "6.0.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz";
        sha512 = "Y38VPSHcqkFrCpFnQ9vuSXmquuv5oXOKpGeT6aGrr3o3Gc9AlVa6JBfUSOCnbxGGZF+/0ooI7KrPuUSztUdU5A==";
      };
    };
    "strip-json-comments-3.1.1" = {
      name = "strip-json-comments";
      packageName = "strip-json-comments";
      version = "3.1.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/strip-json-comments/-/strip-json-comments-3.1.1.tgz";
        sha512 = "6fPc+R4ihwqP6N/aIv2f1gMH8lOVtWQHoqC4yK6oSDVVocumAsfCqjkXnqiYMhmMwS/mEHLp7Vehlt3ql6lEig==";
      };
    };
    "supports-color-7.2.0" = {
      name = "supports-color";
      packageName = "supports-color";
      version = "7.2.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/supports-color/-/supports-color-7.2.0.tgz";
        sha512 = "qpCAvRl9stuOHveKsn7HncJRvv501qIacKzQlO/+Lwxc9+0q2wLyv4Dfvt80/DPn2pqOBsJdDiogXGR9+OvwRw==";
      };
    };
    "tar-4.4.19" = {
      name = "tar";
      packageName = "tar";
      version = "4.4.19";
      src = fetchurl {
        url = "https://registry.npmjs.org/tar/-/tar-4.4.19.tgz";
        sha512 = "a20gEsvHnWe0ygBY8JbxoM4w3SJdhc7ZAuxkLqh+nvNQN2IOt0B5lLgM490X5Hl8FF0dl0tOf2ewFYAlIFgzVA==";
      };
    };
    "tr46-0.0.3" = {
      name = "tr46";
      packageName = "tr46";
      version = "0.0.3";
      src = fetchurl {
        url = "https://registry.npmjs.org/tr46/-/tr46-0.0.3.tgz";
        sha512 = "N3WMsuqV66lT30CrXNbEjx4GEwlow3v6rr4mCcv6prnfwhS01rkgyFdjPNBYd9br7LpXV1+Emh01fHnq2Gdgrw==";
      };
    };
    "type-check-0.3.2" = {
      name = "type-check";
      packageName = "type-check";
      version = "0.3.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/type-check/-/type-check-0.3.2.tgz";
        sha512 = "ZCmOJdvOWDBYJlzAoFkC+Q0+bUyEOS1ltgp1MGU03fqHG+dbi9tBFU2Rd9QKiDZFAYrhPh2JUf7rZRIuHRKtOg==";
      };
    };
    "universalify-0.1.2" = {
      name = "universalify";
      packageName = "universalify";
      version = "0.1.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/universalify/-/universalify-0.1.2.tgz";
        sha512 = "rBJeI5CXAlmy1pV+617WB9J63U6XcazHHF2f2dbJix4XzpUF0RS3Zbj0FGIOCAva5P/d/GBOYaACQ1w+0azUkg==";
      };
    };
    "universalify-2.0.0" = {
      name = "universalify";
      packageName = "universalify";
      version = "2.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/universalify/-/universalify-2.0.0.tgz";
        sha512 = "hAZsKq7Yy11Zu1DE0OzWjw7nnLZmJZYTDZZyEFHZdUhV8FkH5MCfoU1XMaxXovpyW5nq5scPqq0ZDP9Zyl04oQ==";
      };
    };
    "uuid-8.3.2" = {
      name = "uuid";
      packageName = "uuid";
      version = "8.3.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/uuid/-/uuid-8.3.2.tgz";
        sha512 = "+NYs2QeMWy+GWFOEm9xnn6HCDp0l7QBD7ml8zLUmJ+93Q5NF0NocErnwkTkXVFNiX3/fpC6afS8Dhb/gz7R7eg==";
      };
    };
    "webidl-conversions-3.0.1" = {
      name = "webidl-conversions";
      packageName = "webidl-conversions";
      version = "3.0.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/webidl-conversions/-/webidl-conversions-3.0.1.tgz";
        sha512 = "2JAn3z8AR6rjK8Sm8orRC0h/bcl/DqL7tRPdGZ4I1CjdF+EaMLmYxBHyXuKL849eucPFhvBoxMsflfOb8kxaeQ==";
      };
    };
    "whatwg-url-5.0.0" = {
      name = "whatwg-url";
      packageName = "whatwg-url";
      version = "5.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/whatwg-url/-/whatwg-url-5.0.0.tgz";
        sha512 = "saE57nupxk6v3HY35+jzBwYa0rKSy0XR8JSxZPwgLr7ys0IBzhGviA1/TUGJLmSVqs8pb9AnvICXEuOHLprYTw==";
      };
    };
    "which-1.0.9" = {
      name = "which";
      packageName = "which";
      version = "1.0.9";
      src = fetchurl {
        url = "https://registry.npmjs.org/which/-/which-1.0.9.tgz";
        sha512 = "E87fdQ/eRJr9W1X4wTPejNy9zTW3FI2vpCZSJ/HAY+TkjKVC0TUm1jk6vn2Z7qay0DQy0+RBGdXxj+RmmiGZKQ==";
      };
    };
    "winreg-1.2.4" = {
      name = "winreg";
      packageName = "winreg";
      version = "1.2.4";
      src = fetchurl {
        url = "https://registry.npmjs.org/winreg/-/winreg-1.2.4.tgz";
        sha512 = "IHpzORub7kYlb8A43Iig3reOvlcBJGX9gZ0WycHhghHtA65X0LYnMRuJs+aH1abVnMJztQkvQNlltnbPi5aGIA==";
      };
    };
    "word-wrap-1.2.3" = {
      name = "word-wrap";
      packageName = "word-wrap";
      version = "1.2.3";
      src = fetchurl {
        url = "https://registry.npmjs.org/word-wrap/-/word-wrap-1.2.3.tgz";
        sha512 = "Hz/mrNwitNRh/HUAtM/VT/5VH+ygD6DV7mYKZAtHOrbs8U7lvPS6xf7EJKMF0uW1KJCl0H701g3ZGus+muE5vQ==";
      };
    };
    "wrappy-1.0.2" = {
      name = "wrappy";
      packageName = "wrappy";
      version = "1.0.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/wrappy/-/wrappy-1.0.2.tgz";
        sha512 = "l4Sp/DRseor9wL6EvV2+TuQn63dMkPjZ/sp9XkghTEbV9KlPS1xUsZ3u7/IQO4wxtcFB4bgpQPRcR3QCvezPcQ==";
      };
    };
    "yallist-3.1.1" = {
      name = "yallist";
      packageName = "yallist";
      version = "3.1.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/yallist/-/yallist-3.1.1.tgz";
        sha512 = "a4UGQaWPH59mOXUYnAG2ewncQS4i4F43Tv3JoAM+s2VDAmS9NsK8GpDMLrCHPksFT7h3K6TOoUNn2pb7RoXx4g==";
      };
    };
    "yallist-4.0.0" = {
      name = "yallist";
      packageName = "yallist";
      version = "4.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/yallist/-/yallist-4.0.0.tgz";
        sha512 = "3wdGidZyq5PB084XLES5TpOSRA3wjXAlIWMhum2kRcv/41Sn2emQ0dycQW4uZXLejwKvg6EsvbdlVL+FYEct7A==";
      };
    };
    "yauzl-2.10.0" = {
      name = "yauzl";
      packageName = "yauzl";
      version = "2.10.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/yauzl/-/yauzl-2.10.0.tgz";
        sha512 = "p4a9I6X6nu6IhoGmBqAcbJy1mlC4j27vEPZX9F4L4/vZT3Lyq1VkFHw/V/PUcB9Buo+DG3iHkT0x3Qya58zc3g==";
      };
    };
  };
  args = {
    name = "npm-groovy-lint";
    packageName = "npm-groovy-lint";
    version = "11.0.0";
    src = ./.;
    dependencies = [
      sources."@types/sarif-2.1.4"
      (sources."amplitude-5.2.0" // {
        dependencies = [
          sources."axios-0.24.0"
        ];
      })
      sources."ansi-colors-4.1.3"
      sources."ansi-regex-5.0.1"
      sources."ansi-styles-4.3.0"
      sources."argparse-2.0.1"
      sources."at-least-node-1.0.0"
      sources."axios-0.21.4"
      sources."balanced-match-1.0.2"
      sources."brace-expansion-1.1.11"
      sources."buffer-crc32-0.2.13"
      sources."callsites-3.1.0"
      sources."chalk-4.1.2"
      sources."chownr-1.1.4"
      sources."cli-progress-3.11.2"
      sources."color-convert-2.0.1"
      sources."color-name-1.1.4"
      sources."command-exists-promise-2.0.2"
      sources."commondir-1.0.1"
      sources."concat-map-0.0.1"
      sources."debug-4.3.4"
      sources."decode-html-2.0.0"
      sources."deep-is-0.1.4"
      sources."emoji-regex-8.0.0"
      sources."fast-levenshtein-2.0.6"
      sources."fd-slicer-1.1.0"
      (sources."find-java-home-1.2.2" // {
        dependencies = [
          sources."which-1.0.9"
        ];
      })
      sources."find-package-json-1.2.0"
      sources."follow-redirects-1.15.1"
      sources."fs-extra-8.1.0"
      sources."fs-minipass-1.2.7"
      sources."fs.realpath-1.0.0"
      sources."glob-7.2.3"
      sources."graceful-fs-4.2.10"
      sources."has-flag-4.0.0"
      sources."import-fresh-3.3.0"
      sources."inflight-1.0.6"
      sources."inherits-2.0.4"
      sources."ip-1.1.8"
      sources."is-fullwidth-code-point-3.0.0"
      (sources."java-caller-2.4.0" // {
        dependencies = [
          sources."fs-extra-9.1.0"
          sources."jsonfile-6.1.0"
          sources."universalify-2.0.0"
        ];
      })
      sources."js-yaml-4.1.0"
      sources."jsonfile-4.0.0"
      sources."lru-cache-6.0.0"
      sources."minimatch-3.1.2"
      sources."minimist-1.2.6"
      (sources."minipass-2.9.0" // {
        dependencies = [
          sources."yallist-3.1.1"
        ];
      })
      sources."minizlib-1.3.3"
      sources."mkdirp-0.5.5"
      sources."ms-2.1.2"
      sources."njre-0.2.0"
      sources."node-fetch-2.6.7"
      (sources."node-sarif-builder-2.0.2" // {
        dependencies = [
          sources."fs-extra-10.1.0"
          sources."jsonfile-6.1.0"
          sources."universalify-2.0.0"
        ];
      })
      sources."once-1.4.0"
      (sources."optionator-0.8.3" // {
        dependencies = [
          sources."levn-0.3.0"
          sources."prelude-ls-1.1.2"
          sources."type-check-0.3.2"
        ];
      })
      sources."parent-module-1.0.1"
      sources."path-is-absolute-1.0.1"
      sources."pend-1.2.0"
      sources."resolve-from-4.0.0"
      sources."safe-buffer-5.1.2"
      sources."semver-7.3.7"
      sources."string-width-4.2.3"
      sources."strip-ansi-6.0.1"
      sources."strip-json-comments-3.1.1"
      sources."supports-color-7.2.0"
      (sources."tar-4.4.19" // {
        dependencies = [
          sources."safe-buffer-5.2.1"
          sources."yallist-3.1.1"
        ];
      })
      sources."tr46-0.0.3"
      sources."universalify-0.1.2"
      sources."uuid-8.3.2"
      sources."webidl-conversions-3.0.1"
      sources."whatwg-url-5.0.0"
      sources."winreg-1.2.4"
      sources."word-wrap-1.2.3"
      sources."wrappy-1.0.2"
      sources."yallist-4.0.0"
      sources."yauzl-2.10.0"
    ];
    buildInputs = globalBuildInputs;
    meta = {
      description = "Lint, format and auto-fix your Groovy / Jenkinsfile / Gradle files";
      homepage = "https://github.com/nvuillam/npm-groovy-lint#readme";
      license = "GPL-3.0-only";
    };
    production = true;
    bypassCache = true;
    reconstructLock = false;
  };
in
{
  args = args;
  sources = sources;
  tarball = nodeEnv.buildNodeSourceDist args;
  package = nodeEnv.buildNodePackage args;
  shell = nodeEnv.buildNodeShell args;
  nodeDependencies = nodeEnv.buildNodeDependencies (lib.overrideExisting args {
    src = stdenv.mkDerivation {
      name = args.name + "-package-json";
      src = nix-gitignore.gitignoreSourcePure [
        "*"
        "!package.json"
        "!package-lock.json"
      ] args.src;
      dontBuild = true;
      installPhase = "mkdir -p $out; cp -r ./* $out;";
    };
  });
}
