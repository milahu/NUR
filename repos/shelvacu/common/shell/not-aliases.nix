# These are the things that might in a simpler time go in ~/.bashrc as aliases. But they're not aliases, cuz aliases are bad
{
  pkgs,
  lib,
  config,
  vaculib,
  ...
}:
let
  inherit (vaculib) script;
  simple =
    name: args:
    let
      binContents = ''
        #!${lib.getExe pkgs.bash}
        exec ${lib.escapeShellArgs args} "$@"'';
      funcContents = ''
        declare aliasName=${lib.escapeShellArg name}
        declare -a replacementWords=(${lib.escapeShellArgs args})
        declare replacementStr
        declare oldIFS="$IFS"
        IFS=' '
        replacementStr="''${replacementWords[*]}"
        IFS="$oldIFS"
        COMP_LINE="''${COMP_LINE/#$aliasName/$replacementStr}"
        COMP_POINT=$(( COMP_POINT + ''${#replacementStr} - ''${#aliasName} ))
        COMP_CWORD=$(( COMP_CWORD + ''${#replacementWords[@]} - 1 ))
        COMP_WORDS=("''${replacementWords[@]}" "''${COMP_WORDS[@]:1}")
        _comp_command_offset 0
      '';
    in
    pkgs.runCommandLocal "vacu-notalias-simple-${name}"
      {
        pname = name;
        meta.mainProgram = name;
      }
      ''
        mkdir -p "$out"/bin
        printf '%s' ${lib.escapeShellArg binContents} > "$out"/bin/${name}
        chmod a+x "$out"/bin/${name}
        out_base="$(dirname -- "$out")"
        LC_ALL=C
        completion_function_name="_completion_''${out_base//[^a-zA-Z0-9_]/_}"
        completion_file="$out"/share/bash-completion/completions/${name}
        mkdir -p "$(dirname -- "$completion_file")"
        printf '%s() {\n%s\n}\n' "$completion_function_name" ${lib.escapeShellArg funcContents} > "$completion_file"
        printf 'complete -F %s %s\n' "$completion_function_name" ${lib.escapeShellArg name} >> "$completion_file"
      '';
  ms_text = with_sudo: ''
    svl_minmax_args $# 1 3
    host="$1"
    session_name="''${2:-main}"
    set -x
    mosh -- "$host" ${lib.optionalString with_sudo "sudo"} screen -RdS "$session_name"
  '';
  systemctl = "${pkgs.systemd}/bin/systemctl";
  journalctl = "${pkgs.systemd}/bin/journalctl";
in
{
  imports = [ { vacu.packages.copy-altcaps.enable = config.vacu.isGui; } ];
  vacu.packages = [
    (script "ms" (ms_text false))
    (script "mss" (ms_text true))
    (script "msl" ''
      svl_exact_args $# 1
      host="$1"
      echo 'echo "user:"; screen -ls; echo; echo "root:"; sudo screen -ls' | ssh -T "$host"
    '')
    (script "rmln" ''
      svl_min_args $# 1
      for arg in "$@"; do
        if [[ "$arg" != -* ]] && [[ ! -L "$arg" ]]; then
          die "$arg is not a symlink"
        fi
      done
      rm "$@"
    '')
    (script "copy-altcaps" ''
      result="$(altcaps "$@")"
      printf '%s' "$result" | wl-copy
      echo "Copied to clipboard: $result"
    '')
    (script "nr" ''
      # nix run nixpkgs#<thing> -- <args>
      svl_min_args $# 1
      installable="$1"
      shift
      if [[ "$installable" != *'#'* ]]; then
        installable="nixpkgs#$installable"
      fi
      nix run "$installable" -- "$@"
    '')
    (script "nb" ''
      # nix build nixpkgs#<thing> <args>
      svl_min_args $# 1
      installable="$1"
      shift
      if [[ "$installable" != *'#'* ]]; then
        installable="nixpkgs#$installable"
      fi
      nix build "$installable" "$@"
    '')
    (script "ns" ''
      # nix shell nixpkgs#<thing>
      svl_min_args $# 1
      new_args=( )
      for arg in "$@"; do
        if [[ "$arg" != *'#'* ]] && [[ "$arg" != -* ]]; then
          arg="nixpkgs#$arg"
        fi
        new_args+=("$arg")
      done
      nix shell "''${new_args[@]}"
    '')
    (script "nixview" ''
      svl_min_args $# 1
      view_cmd="$1"
      shift
      d="$(mktemp -d --suffix=vacu-nixview)"
      l="$d/out"
      nix build --out-link "$l" "$@"
      "$view_cmd" "$l"
      rm -r "$d"
    '')
    (simple "nixcat" [
      "nixview"
      "cat"
    ])
    (simple "nixless" [
      "nixview"
      "less"
    ])
    (simple "sc" [ systemctl ])
    (simple "scs" [
      systemctl
      "status"
      "--lines=20"
      "--full"
    ])
    (simple "scc" [
      systemctl
      "cat"
    ])
    (simple "scr" [
      systemctl
      "restart"
    ])
    (simple "jc" [
      journalctl
      "--pager-end"
    ])
    (simple "jcu" [
      journalctl
      "--pager-end"
      "-u"
    ])
    (simple "gs" [
      "git"
      "status"
    ])
    (script "list-auto-roots" ''
      auto_roots="/nix/var/nix/gcroots/auto"
      svl_exact_args $# 0
      echo "List of auto-added nix gcroots, excluding system profiles:"
      echo
      for fn in "$auto_roots/"*; do
        if ! [[ -L "$fn" ]]; then
          die "fn is not a symlink!?: $fn"
        fi
        pointed="$(readlink -v -- "$fn")"
        if ! [[ -e "$pointed" ]]; then
          continue
        fi
        if [[ "$pointed" == /nix/var/nix/profiles/system-* ]]; then
          continue
        fi
        printf '%s\n' "$pointed"
      done
    '')
  ];
  vacu.shell.functions = {
    nd = ''
      svl_min_args $# 1
      declare -a args=("$@")
      lastarg="''${args[-1]}"
      if [[ "$lastarg" == "-"* ]]; then
        echo "nd: last argument must be the directory" 1>&2
        return 1
      fi
      for arg in "''${args[@]::''${#args[@]}-1}"; do
        if [[ "$arg" != "-"* ]]; then
          echo "nd: last argument must be the directory" 1>&2
          return 1
        fi
      done
      mkdir "''${args[@]}" && cd "''${args[-1]}"
    '';
    nt = ''pushd "$(mktemp -d "$@")"'';
  };
  vacu.textChecks."vacu-shell-functions-nd" = ''
    source ${lib.escapeShellArg pkgs.shellvaculib.file}
    function nd() {
      ${config.vacu.shell.functions.nd}
    }

    start=/tmp/test-place
    mkdir -p $start
    cd $start
    nd a
    [[ "$PWD" == "$start/a" ]]
    cd $start
    nd -p b/c
    [[ "$PWD" == "$start/b/c" ]]
  '';
  vacu.textChecks."vacu-shell-functions-nt" = ''
    source ${lib.escapeShellArg pkgs.shellvaculib.file}
    function nt() {
      ${config.vacu.shell.functions.nt}
    }
    start=$PWD
    nt
    [[ "$PWD" != "$start" ]]
    popd
    [[ "$PWD" == "$start" ]]
  '';
}
