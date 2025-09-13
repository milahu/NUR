{ config, lib, pkgs, ... }:

let
  inherit (builtins) mapAttrs readFile toFile;
  inherit (lib) concatLines concatStrings concatStringsSep escapeShellArg genAttrs getExe getExe' mapAttrsToList mkMerge mkOrder;
  inherit (pkgs) replaceVars runtimeShell starship-jj;
  inherit (pkgs.writers) writeTOML;
  inherit (import ../library/utilities.lib.nix { inherit lib; }) sgr;

  toAbbrs = kv: concatLines (mapAttrsToList (k: v: "abbr ${k}=${escapeShellArg v}") kv);
in
{
  programs.bash = {
    enable = true;
    historyControl = [ "ignorespace" ];
    historyFile = "${config.home.homeDirectory}/akorg/resource/bash-history";
    historyFileSize = 1000000000;
    historySize = 100000000;
    initExtra = with sgr; ''
      HISTTIMEFORMAT='%FT%T%z ' # RFC 3339
      PS1='\[${magenta "\\]$\\["}\] '
    '';
  };

  programs.bat.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    config.global.warn_timeout = "5m";
    stdlib = with pkgs; ''
      # Adapted from https://github.com/direnv/direnv/wiki/Customizing-cache-location
      declare -A direnv_layout_dirs
      direnv_layout_dir() {
        local hash name
        echo "''${direnv_layout_dirs[$PWD]:=$(
          case "$PWD" in
            "$HOME/project/"*|"$HOME/akorg/project/"*) store='user-state-cache';;
            *) store='user-runtime';;
          esac
          hash="$(sha256sum <<< "$PWD" | head --bytes 16)"
          name="''${PWD//\//-}"; name="''${name:1}"
          systemd-path --suffix "direnv/layouts/$name#$hash" "$store"
        )}"
      }

      layout_uv() {
        layout python
        export UV_PROJECT_ENVIRONMENT="$VIRTUAL_ENV"
        unset 'VIRTUAL_ENV'
      }

      use_gopass() {
        eval "$(${getExe gopass-await} "$@")"
      }
    '';
  };

  programs.eza.enable = true;

  programs.fzf = rec {
    enable = true;
    enableZshIntegration = true;
    defaultOptions = [ "--height 33%" "--no-separator" "--reverse" ];
    defaultCommand = "fd --no-ignore-parent --one-file-system --type file";
    fileWidgetCommand = defaultCommand;
    changeDirWidgetCommand = "fd --no-ignore-parent --one-file-system --type directory";
  };

  programs.starship = {
    enable = true;

    settings =
      let
        contextStyle = "bg:black fg:white bold";
        directoryBg = "purple";
      in
      {
        format = concatStrings [
          "([ $username(@$hostname) ](${contextStyle})[](bg:${directoryBg} fg:prev_bg))"
          "[ $directory ](bg:${directoryBg} fg:black bold)"
          "([](bg:blue fg:prev_bg)[( \${custom.git_commit})( \${custom.git_branch})( \${custom.git_tag})$git_status( \${custom.git_dirty})( $git_state)( \${custom.jj}) ](bg:blue fg:black bold))"
          "([](bg:green fg:prev_bg)[( $shell)( $nix_shell) ](bg:green fg:black bold))"
          "[](fg:prev_bg) "
        ];
        right_format = concatStrings [
          "([](fg:red)[ $status ](bg:red fg:black bold))"
          "([](bg:prev_bg fg:cyan)[ $jobs ](bg:cyan fg:black bold))"
        ];
        continuation_prompt = "[┃](bright-black) ";

        # TODO: Resolve starship/starship#3036
        # TODO: Resolve starship/starship#3653
        directory = {
          format = "$path";
        };
        git_branch = {
          disabled = true;
          format = "$branch";
          only_attached = true;
        };
        git_commit = {
          disabled = true;
          format = "$hash";
        };
        git_state = {
          format = "$state";
        };
        git_status = {
          format = "( $ahead_behind)( $stashed)( $staged)";
          staged = "±";
          stashed = "⮌";
        };
        hostname = {
          format = "$hostname";
          trim_at = "";
        };
        jobs = {
          format = "$symbol";
          symbol = "⋮";
        };
        nix_shell = {
          format = "$symbol";
          symbol = "󱄅 ";
        };
        shell = {
          disabled = false;
          format = "$indicator";
          bash_indicator = "\\$";
          zsh_indicator = "";
        };
        status = {
          disabled = false;
          format = "$status";
          style = "";
          recognize_signal_code = false;
        };
        username = {
          format = "[$user]($style)";
          style_user = contextStyle;
          style_root = "${contextStyle} fg:red";
        };

        custom = mapAttrs (_: c: { shell = [ runtimeShell "--noprofile" "--norc" ]; } // c) {
          # Workaround for starship/starship#5932, lanastara_foss/starship-jj#5
          git_branch = {
            require_repo = true;
            when = "! jj --ignore-working-copy root";
            command = "starship module git_branch";
            format = "$output";
          };

          # Workaround for starship/starship#5932, lanastara_foss/starship-jj#5
          git_commit = {
            require_repo = true;
            when = "! jj --ignore-working-copy root";
            command = "starship module git_commit";
            format = "$output";
          };

          # Workaround for starship/starship#1192
          git_dirty = {
            require_repo = true;
            when = "! jj --ignore-working-copy root && [[ -n \"$(git status --porcelain | grep --invert-match '^A')\" ]]";
            format = "$symbol";
            symbol = "·";
          };

          # Workaround for starship/starship#4830
          git_tag = {
            require_repo = true;
            when = "! jj --ignore-working-copy root";
            command = "git describe --abbrev=0 --exact-match --tags HEAD";
            format = "$output";
          };

          # Workaround for starship/starship#6076
          jj =
            let
              config = writeTOML "starship-jj-config" {
                reset_color = false;
                module = [
                  {
                    type = "Bookmarks";
                    max_bookmarks = 1;
                    separator = " ";
                    surround_with_quotes = false;
                    behind_symbol = "⇡";
                    bg_color = "Blue";
                    color = "Black";
                  }
                  {
                    type = "Commit";
                    max_length = 16;
                    surround_with_quotes = true;
                    empty_text = "TODO";
                    bg_color = "Blue";
                    color = "Black";
                  }
                  {
                    type = "State";
                    separator = " ";
                    conflict = { text = "[conflict]"; bg_color = "Blue"; color = "Black"; };
                    divergent = { text = "[divergent]"; bg_color = "Blue"; color = "Black"; };
                    empty = { text = "[empty]"; bg_color = "Blue"; color = "Black"; };
                    immutable = { text = "[immutable]"; bg_color = "Blue"; color = "Black"; };
                    hidden = { text = "[hidden]"; bg_color = "Blue"; color = "Black"; };
                  }
                ];
              };
            in
            {
              require_repo = true;
              when = true;
              command = "${getExe starship-jj} --ignore-working-copy starship prompt --starship-config=${config}";
              ignore_timeout = true;
              format = "$output";
            };
        };
      };
  };

  programs.zsh = {
    enable = true;
    autocd = false;

    history = {
      path = "${config.home.homeDirectory}/akorg/resource/zsh-history";
      expireDuplicatesFirst = true;
      extended = true;
      ignoreDups = false;
      ignoreSpace = true;
      save = 100000000;
      size = 1000000000;
    };

    localVariables = {
      HIST_STAMPS = "yyyy-mm-dd";
      REPORTTIME = 10;
      WORDCHARS = "_.~;!#$%^";
    };

    initContent = with pkgs; let completion = 550; default = 1000; in mkMerge [
      # Completions
      (mkOrder completion ''
        fpath+=(${zsh-completions}/src)
      '')

      # Main
      (mkOrder default (readFile (replaceVars ./assets/init.zsh {
        pdfimages = (getExe' poppler_utils "pdfimages");
        zsh-abbr = "${zsh-abbr}/share/zsh/plugins/zsh-abbr/zsh-abbr.plugin.zsh";
        zsh-click = "${zsh-click}/share/zsh/plugins/click/click.plugin.zsh";
        zsh-complete-git-commit-message = toFile "zsh-complete-git-commit-message" (readFile ./assets/complete-git-commit-message.zsh);
        zsh-completion-sync = "${zsh-completion-sync}/share/zsh/plugins/zsh-completion-sync/zsh-completion-sync.plugin.zsh";
        zsh-prezto-terminal = "${zsh-prezto}/share/zsh-prezto/modules/terminal/init.zsh";
        zsh-starship-issue-4205 = toFile "zsh-starship-issue-4205" (readFile ./assets/starship-issue-4205.zsh);
        zsh-syntax-highlighting = "${zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";
      })))
    ];

    shellAliases =
      (genAttrs [ "git" "yt-dlp" ] (c: "noglob ${c}"))
      // {
        all-history = "fc -l -Di 0";
        as = "gopass-env";
        cat = "bat --plain";
        cp = "cp --reflink=auto";
        get-clipboard = "wl-paste --no-newline --type 'text'";
        get-public-ip = "${getExe pkgs.dig} +short @208.67.222.222 myip.opendns.com";
        e = "eza --all --group-directories-first --long --header --time-style long-iso";
        ffmpeg = "ffmpeg -hide_banner";
        ffprobe = "ffprobe -hide_banner";
        home-manager = "nom-home-manager";
        http = "noglob xh";
        https = "noglob xhs";
        j = "just-local";
        lsblk = "lsblk --output 'name,type,uuid,label,size,fstype,mountpoints' --paths";
        mv = "mv --no-clobber --verbose";
        nixos-rebuild = "nom-nixos-rebuild";
        p = "gopass";
        path = "nix-build --pure '<nixpkgs>' --attr";
        pt = "gopass-ydotool";
        remove-known-host = "ssh-keygen -R";
        rm = "rm --one-file-system --verbose";
        rsync = "rsync --compress --compress-choice=zstd --human-readable";
        set-clipboard = "wl-copy --type 'TEXT'";
        ssh-copy-id = "ssh-copy-id -o 'PreferredAuthentications=password'";
        ssh-ephemeral = "ssh -o StrictHostKeyChecking='no' -o UserKnownHostsFile='/dev/null'";
        uv-outdated = "uv tree --depth '1' --outdated";
        watch = "watch --color";
        wd = "git diff --no-index --word-diff --word-diff-regex '.'";
        xev = "echo 'Use ${sgr.bold "wev"} instead.' >&2; return 1";
      };
  };

  xdg.configFile."zsh/abbreviations".text = toAbbrs {
    a = "git add --patch";
    aw = "add-words";
    b = "git switch --create";
    c = "git commit";
    ca = "git commit --amend";
    cb = "git-remote codeberg.org";
    cf = "git commit --amend --no-edit";
    cm = "git commit --message";
    d = "git diff ':!*.lock'";
    dl = "http --download get";
    ds = "git diff --staged ':!*.lock'";
    dsw = "git diff --staged --ignore-all-space ':!*.lock'";
    dua = "dua --stay-on-filesystem interactive";
    dw = "git diff --ignore-all-space ':!*.lock'";
    eh = "email-hash";
    et = "e --tree";
    f = "git commit --fixup";
    gf = "git fetch --all --jobs 4 --prune";
    gff = "git fetch --all --jobs 4 --prune && git merge --ff-only";
    gh = "git-remote github.com";
    gist = "git-remote gist.github.com";
    gl = "git-remote gitlab.com";
    gnome-console = "kgx";
    h = "tig --all";
    hs = "home-manager switch";
    i = "jjui";
    jd = "jj diff";
    jf = "jj git fetch";
    jl = "jj status";
    jm = "jj resolve --tool mergiraf";
    jp = "jj git push";
    jr = "jj restore --interactive";
    js = "jj commit --interactive";
    jt = "jj tug";
    jtp = "jj tug && jj git push";
    n = "numbat";
    np = "nix-shell --packages";
    rebase = "git rebase --autostash --autosquash --interactive";
    s = "git status";
    stash = "git stash save --include-untracked";
    undo = "git restore --patch";
  };

  home.sessionVariables.EZA_COLORS = concatStringsSep ":" (mapAttrsToList (k: v: "${k}=${(v null).on}") (with sgr; {
    ur = dim white; # permission user-read
    uw = dim white; # permission user-write
    ux = bold green; # permission user-execute when file
    ue = bold green; # permission user-execute when other
    gr = dim white; # permission group-read
    gw = dim white; # permission group-write
    gx = dim white; # permission group-execute
    tr = bold magenta; # permission others-read
    tw = bold red; # permission others-write
    tx = dim white; # permission others-execute
    su = bold yellow; # permissions setuid/setgid/sticky when file
    sf = bold yellow; # permissions setuid/setgid/sticky when other
    xa = bold yellow; # extended attribute
    sn = dim white; # size numeral
    ub = bold white; # size unit when unprefixed
    uk = bold blue; # size unit when K
    um = bold yellow; # size unit when M
    ug = bold red; # size unit when G
    ut = bold red; # size unit when ≥T
    uu = dim white; # user when self
    un = red; # user when other
    gu = dim white; # group when member
    gn = red; # group when other
    da = dim italic white; # date
    lp = dim white; # symlink path
    cc = bold yellow; # escaped character
  }));

  home.sessionVariables.LS_COLORS = concatStringsSep ":" (mapAttrsToList (k: v: "${k}=${(v null).on}") (with sgr; {
    di = bold blue; # directories
    ex = green; # executable files
    fi = white; # regular files
    pi = italic cyan; # named pipes
    so = italic cyan; # sockets
    bd = bold cyan; # block devices
    cd = bold cyan; # character devices
    ln = magenta; # symlinks
    or = red; # symlinks with no target
  }));
}
