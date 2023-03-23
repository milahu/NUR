{ config, pkgs, lib, ... }:
let
  cfg = config.my.home.zsh;

  # Have a nice relative path for XDG_CONFIG_HOME, without leading `/`
  relativeXdgConfig =
    let
      noHome = lib.removePrefix config.home.homeDirectory;
      noSlash = lib.removePrefix "/";
    in
    noSlash (noHome config.xdg.configHome);
in
{
  options.my.home.zsh = with lib; {
    enable = my.mkDisableOption "zsh configuration";

    launchTmux = mkEnableOption "auto launch tmux at shell start";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      zsh-completions
    ];

    programs.zsh = {
      enable = true;
      dotDir = "${relativeXdgConfig}/zsh"; # Don't clutter $HOME
      enableCompletion = true;

      history = {
        size = 500000;
        save = 500000;
        extended = true;
        expireDuplicatesFirst = true;
        ignoreSpace = true;
        ignoreDups = true;
        share = false;
        path = "${config.xdg.dataHome}/zsh/zsh_history";
      };

      plugins = with pkgs; [
        {
          name = "fast-syntax-highlighting";
          file = "share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh";
          src = pkgs.zsh-fast-syntax-highlighting;
        }
        {
          name = "agkozak-zsh-prompt";
          file = "share/zsh/site-functions/agkozak-zsh-prompt.plugin.zsh";
          src = pkgs.agkozak-zsh-prompt;
        }
      ];

      # Modal editing is life, but CLI benefits from emacs gymnastics
      defaultKeymap = "emacs";

      # Make those happen early to avoid doing double the work
      initExtraFirst = ''
        ${
          lib.optionalString cfg.launchTmux ''
            # Launch tmux unless already inside one
            if [ -z "$TMUX" ]; then
              exec tmux new-session
            fi
          ''
        }
      '';

      initExtra = ''
        source ${./completion-styles.zsh}
        source ${./extra-mappings.zsh}
        source ${./options.zsh}

        # Source local configuration
        if [ -f "$ZDOTDIR/zshrc.local" ]; then
          source "$ZDOTDIR/zshrc.local"
        fi
      '';

      localVariables = {
        # I like having the full path
        AGKOZAK_PROMPT_DIRTRIM = 0;
        # Because I *am* from EPITA
        AGKOZAK_PROMPT_CHAR = [ "42sh$" "42sh#" ":" ];
        # Easy on the eyes
        AGKOZAK_COLORS_BRANCH_STATUS = "magenta";
        # I don't like moving my eyes
        AGKOZAK_LEFT_PROMPT_ONLY = 1;
      };

      shellAliases = {
        # I like pretty colors
        diff = "diff --color=auto";
        grep = "grep --color=auto";
        egrep = "egrep --color=auto";
        fgrep = "fgrep --color=auto";
        ls = "ls --color=auto";

        # Well-known ls aliases
        l = "ls -alh";
        ll = "ls -l";

        # Sometime `gpg-agent` errors out...
        reset-agent = "gpg-connect-agent updatestartuptty /bye";
      };

      # Enable VTE integration
      enableVteIntegration = true;
    };

    # Fuzzy-wuzzy
    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.dircolors = {
      enable = true;
    };
  };
}
