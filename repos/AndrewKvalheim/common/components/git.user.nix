{ lib, pkgs, ... }:

let
  inherit (builtins) listToAttrs;
  inherit (lib) getExe getExe' mkForce nameValuePair range;
  inherit (pkgs.writers) writeTOML;

  identity = import ../resources/identity.nix;
  palette = import ../resources/palette.nix { inherit lib pkgs; };
in
{
  home.packages = with pkgs; [
    delta
    git-absorb
    git-filter-repo
    git-remote
    jjui
    tig
  ];

  programs.git = {
    enable = true;
    lfs.enable = true;

    userName = identity.name.long;
    userEmail = identity.email;
    signing.key = identity.openpgp.id;

    aliases = {
      diff-image = "!f() { cd -- \"\${GIT_PREFIX:-.}\"; GIT_DIFF_IMAGE_ENABLED=1 git diff \"$@\"; }; f";
      ff = "merge --ff-only";
      kitty = "difftool --tool=kitty --no-symlinks --dir-diff";
      puff = "pull --ff-only";
      recent = "!git --no-pager log --max-count 8 --pretty=tformat:\"%w($(tput cols),0,8)%C(cyan)%h%Creset %C(yellow)%cr:%C(magenta)%d%Creset %s\"";
    };

    attributes = [
      "*.gif diff=image"
      "*.jpg diff=image"
      "*.png diff=image"
      "*.sfdir/*.glyph filter=sfd"
    ];

    ignores = [
      ".direnv/"
      ".envrc"
      ".envrc.gemset.nix"
      ".envrc.nix"
      ".local.justfile"
      ".venv/"
      ".vscode/"
      "result"
    ];

    delta = {
      enable = true;
      options =
        with palette.hex; {
          file-renamed-label = "moved:";
          line-numbers-left-format = "{nm:>1} ";
          line-numbers-left-style = "${white-dark} bold";
          line-numbers-minus-style = "${vermilion-dark} bold";
          line-numbers-plus-style = "${teal-dark} bold";
          line-numbers-right-format = "{np:>1}▐";
          line-numbers-right-style = "${white-dark} bold";
          line-numbers-zero-style = "${white-dark} bold";
          minus-emph-style = "${vermilion-dark-contrast-minimum} ${vermilion-dark}";
          minus-empty-line-marker-style = "normal ${vermilion-dark}";
          minus-non-emph-style = "${white-dim} dim";
          minus-style = "${vermilion-dark-contrast-minimum} ${vermilion-dark}";
          plus-emph-style = "syntax ${teal-dark}";
          plus-empty-line-marker-style = "normal ${teal-dark}";
          plus-non-emph-style = "syntax dim";
          plus-style = "syntax ${teal-dark}";
          syntax-theme = "Monokai Extended";
          whitespace-error-style = "reverse white";
          wrap-max-lines = "unlimited";
          zero-style = "syntax dim";

          full = {
            file-style = "white bold";
            file-decoration-style = "omit";
            hunk-header-style = "omit";
            line-numbers = true;
          };
        };
    };
    iniContent.core.pager = mkForce "${getExe pkgs.delta} --color-only --features full"; # Set feature

    extraConfig = {
      branch.sort = "-committerdate";
      commit.verbose = true;
      core.autocrlf = "input";
      diff.algorithm = "histogram";
      diff.mnemonicPrefix = true;
      diff.renames = true;
      fetch.all = true;
      fetch.prune = true;
      fetch.pruneTags = true;
      init.defaultBranch = "main";
      merge.commit = false;
      merge.conflictStyle = "zdiff3";
      merge.tool = "code";
      push.followTags = true;
      rebase.autoSquash = true;
      rebase.autoStash = true;
      rebase.updateRefs = true;
      rerere.autoupdate = true;
      rerere.enabled = true;
      tag.sort = "version:refname";

      diff.anvil.textconv = getExe pkgs.git-diff-minecraft;
      diff.image.command = getExe' pkgs.git-diff-image "git_diff_image";
      difftool = { prompt = false; trustExitCode = true; };

      filter.sfd.clean = "sed '/^Flags:/s/[OS]//g'"; # Unset (O)pen, (S)elected

      tig = {
        line-graphics = "utf-8";
        main-view-date = "custom";
        main-view-date-format = "%F %H:%M";
        main-view-date-use-author = true;
        main-view-id-display = true;
        show-changes = false;
        tab-size = 4;
        truncation-delimiter = "utf-8";
        vertical-split = false;
        color = (listToAttrs (map (n: nameValuePair "palette-${toString n}" "color8 default") (range 0 13))) // {
          author = "color8 default";
          cursor = "black magenta bold";
          graph-commit = "magenta default";
          date = "yellow default";
          id = "cyan default";
          main-head = "magenta default bold";
          main-local-tag = "green default";
          main-ref = "magenta default";
          main-remote = "blue default";
          main-tag = "green default";
          main-tracked = "blue default bold";
          search-result = "black white bold";
          title-blur = "white black";
          title-focus = "white black bold";
        };
        bind.generic = "d @kitten @ launch --self --type=overlay --title=current --cwd=current --env DELTA_PAGER='less -+F' git show %(commit)"; # Pending jonas/tig#542
      };
    };
  };

  programs.jujutsu = {
    enable = true;

    settings = {
      user.name = identity.name.long;
      user.email = identity.email;

      merge-tools = {
        delta = {
          program = getExe pkgs.delta;
          diff-args = [ "--features" "full" "$left" "$right" ];
          diff-expected-exit-codes = [ 0 /* same */ 1 /* different */ ];
        };
      };

      # Reference: https://github.com/jj-vcs/jj/blob/main/cli/src/config/templates.toml
      template-aliases = {
        "format_short_signature_oneline(s)" = "coalesce(s.name(), s.email(), name_placeholder)";
      };

      templates = {
        log = "builtin_log_oneline";
      };

      ui = {
        diff-formatter = "delta";
        pager = "less --no-init --quit-if-one-screen --RAW-CONTROL-CHARS"; # Override PAGER with Jujutsu default
      };

      # Reference: https://github.com/jj-vcs/jj/blob/main/cli/src/config/colors.toml
      colors = rec {
        change_id = "cyan";
        commit_id = "bright black";

        "working_copy commit_id" = commit_id;
        "working_copy change_id" = change_id;

        "diff empty" = "blue";
        "diff binary" = "blue";
        "diff hunk_header" = "blue";
        "diff modified" = "blue";
        "diff untracked" = "yellow";
        "diff renamed" = "blue";

        "node working_copy" = "magenta";
      };

      aliases = {
        consume = [ "squash" "--interactive" "--into" "@" "--from" ];
        eject = [ "squash" "--interactive" "--from" "@" "--into" ];
        recent = [ "log" "--limit" "8" ];
        tug = [ "bookmark" "move" "--from" "heads(::@- & bookmarks())" "--to" "@-" ];
      };

      "--scope" = [
        {
          "--when".commands = [ "log" ];
          template-aliases = {
            "format_timestamp(t)" = "t.local().format(\"%F\")";
            description_placeholder = "label(\"description placeholder\", \"⯈\")";
          };

          colors = rec {
            author = "bright black";
            committer = "bright black";

            "working_copy author" = author;
            "working_copy committer" = committer;
          };
        }
      ];
    };
  };

  # Reference: https://github.com/idursun/jjui/blob/main/internal/config/default/config.toml
  xdg.configFile."jjui/config.toml".source = writeTOML "jjui-config" {
    # Reference: https://github.com/idursun/jjui/blob/main/internal/config/default/default_dark.toml
    ui.colors = {
      "revisions selected" = { fg = "white"; bg = "black"; };
    };
  };
}
