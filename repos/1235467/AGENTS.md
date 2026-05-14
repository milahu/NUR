# Nix Packaging Workflow for this Repo

## Critical Rules
1. **Git Awareness**: This is a Flake-based repo. Nix CANNOT see any files that are not staged in Git.
   - ALWAYS run `git add <new_files>` before running `nix build`.
   - Never try to build a package if the `.nix` file is "untracked".

2. **Hash Strategy**:
   - Use `lib.fakeHash` or `sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=` as a placeholder.
   - Run `nix build .#<pkg>` and capture the "got:" hash from the error message.
   - Use the built-in `apply_patch` tool (or equivalent editor) to update the hash, **not** `sed` or `cat`.

3. **Build Outputs (`result` symlink)**:
   - `nix build` usually creates a `./result` symlink in the repo root (or `result-2`, `result-3`, etc. if one already exists).
   - This symlink points to the built package output in `/nix/store`, and is the quickest way to inspect what the derivation actually installed.
   - Use it to verify output layout such as `bin/`, `lib/`, `share/`, wrappers, desktop files, and other installed artifacts.
   - `result` is **not** source code and should not be edited or committed; it is disposable and can always be recreated by rebuilding.

4. **Editing Files**:
   - **Always use the built-in file edit tool (or equivalent code editor) to edit files.**
   - Do NOT use shell commands like `sed`, `cat << EOF > file`, or `echo >> file` to modify files.
   - The patch tool ensures clean, diff-based edits and prevents accidental corruption.

5. **Language-Specific Packaging**:
   - Each language has its own build system (e.g., `buildGoModule` for Go, `buildPythonPackage` for Python, `cmake` for C/C++, etc.).
   - Always check the upstream source for build instructions and required dependencies.
   - If a hash argument is required by the build system and unknown, set it to `lib.fakeHash`.

6. **Directory Structure**:
   - Packages are organized by language under `./pkgs-by-lang/<Language>/<name>/default.nix`.
   - Always register the new package in `flake.nix` or the corresponding language-specific overlay.

7. **git cli is available**

## Reference Documentation

- `docs_for_agents/nixpkgs_manual.md` contains Nix packaging reference material.
  - This file is large (~30K lines). **Do not read it in full.**
  - Only open the sections relevant to the language/build system you're packaging,
    plus any other procedures you actually need (e.g., hash resolution, overlay registration).

### Section Index (`docs_for_agents/nixpkgs_manual.md`)

General packaging topics:

| Topic | Line |
|---|---|
| **Overlays** | 893 |
| **Overriding** (`override`, `overrideAttrs`, `overrideDerivation`) | 1047 |
| **Standard Environment** / `stdenv.mkDerivation` | 9521 |
| **Source fetchers** (`fetchFromGitHub`, `fetchurl`, `fetchgit`, etc.) | 11947 |
| **Updating source hashes** (fake hash method) | 12009 |
| **Obtaining hashes securely** | 12057 |
| **Trivial build helpers** (`runCommand`, `writeShellApplication`, etc.) | 12600 |
| **Special build helpers** (`mkShell`, `vmTools`, etc.) | 13528 |
| Quick Start (moved to `pkgs/README.md`) | 28966 |
| Coding conventions (moved to `CONTRIBUTING.md`) | 28976 |

Language/build-system topics currently relevant to this repo (`pkgs-by-lang/{C,Dotnet,Go,Node,Python,Rust,Shell}`):

| Topic | Line |
|---|---|
| **Shell**: `writeShellScriptBin` | 12964 |
| **Shell**: `writeShellApplication` | 13038 |
| **C/C++**: `cmake` | 14976 |
| **C/C++**: `Meson` | 15263 |
| **Dotnet** overview | 18241 |
| **Dotnet**: `buildDotnetModule` | 18337 |
| **Dotnet**: `buildDotnetGlobalTool` | 18448 |
| **Dotnet**: NuGet deps / `deps.json` / `fetch-deps` | 18482 |
| **Go** overview | 18992 |
| **Go**: `buildGoModule` | 19002 |
| **Go**: versioned toolchains/builders | 19171 |
| **Node.js**: `buildNpmPackage` | 21013 |
| **Node.js**: `prefetch-npm-deps` | 21082 |
| **Node.js**: `fetchNpmDeps` | 21092 |
| **Node.js**: `importNpmLock` | 21101 |
| **Node.js**: `pnpm` | 21192 |
| **Node.js**: Yarn v1 (`fetchYarnDeps`, hooks, `mkYarnPackage`) | 21385 |
| **Node.js**: Yarn Berry v3/v4 | 21572 |
| **Python** overview | 23566 |
| **Python**: `buildPythonPackage` | 23655 |
| **Python**: `buildPythonPackage` parameters | 23737 |
| **Rust** overview | 25735 |
| **Rust**: `buildRustPackage` | 25754 |
| **Rust**: `cargoHash` / `cargoLock` notes | 25785 / 25823 |

Other common language/build-system topics not currently used in this repo:

| Topic | Line |
|---|---|
| **Java** overview / JAR install layout / wrapper scripts | 20827 |
| **Gradle**: build flow / `gradle.fetchDeps` / update script / env vars | 19282 / 19372 / 19400 |
| **Maven**: `maven.buildMavenPackage` | 22225 |
| **Maven**: `mvn2nix` (legacy / manual path) | 22351 |
| **Haskell** overview | 19479 |
| **Haskell**: `haskellPackages.mkDerivation` | 19577 |
| **Haskell**: development environments | 19852 |
| **Haskell**: overrides | 19973 |
| **Haskell**: `cabal2nix` / `callCabal2nix` | 20222 / 20248 |
| **OCaml** overview | 22898 |
| **OCaml**: packaging guide / `buildDunePackage` patterns | 22930 |
| **Perl** overview | 23113 |
| **Perl**: `buildPerlPackage` | 23139 |
| **Perl**: generation from CPAN | 23250 |
| **Lua** overview | 21995 |
| **Lua**: packaging via luarocks / manual packaging | 22107 / 22119 |
| **Lua**: `buildLuarocksPackage` / `lua.withPackages` | 22148 / 22200 |
| **PHP** overview | 23279 |
| **PHP**: extensions / `php.withExtensions` | 23299 |
| **PHP**: Composer projects / `php.buildComposerProject2` | 23423 |
| **Ruby** overview / `ruby.withPackages` | 25438 |
| **Ruby**: existing `Gemfile` / `bundlerEnv` | 25510 |
| **Ruby**: packaging applications (`bundlerApp`) | 25675 |
