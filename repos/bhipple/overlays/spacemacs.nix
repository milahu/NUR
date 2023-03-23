self: super:
let
  myEmacsPkgs = ep: with ep.melpaPackages; [
    # There's a bug in the current source of evil-escape that causes it to
    # fail to build. We'll patch it out for now and hope it gets fixed in a
    # future version.
    (
      ep.evil-escape.overrideAttrs (
        o: {
          patches = (o.patches or [ ]) ++ [
            (
              super.fetchpatch {
                url = https://github.com/BrianHicks/evil-escape/commit/b548e8450570a0c8dea47b47221b728c047a9baf.patch;
                sha256 = "1a2qrf4bpj7wm84qa3haqdg3pd9d8nh5vrj8v1sc0j1a9jifsbf6";
              }
            )
          ];
        }
      )
    )

    # Not packaged
    # company-ghc
    # company-ghci
    # evil-unimpaired
    # ghc
    # git-gutter-fringe-plus
    # git-gutter-plus
    # hybrid-mode
    # intero
    # vertico
    # vertico-repeat

    # Packaged, but has some build issue not worth resolving (fill in gaps with use-package)
    # dap-mode              ; bad hash on dependency bui-mode
    # dired-quick-sort      ; can't mirror gitlab commit
    # emr                   ; transitive dep on paredit
    # evil-cleverparens     ; transitive dep on paredit
    # eyebrowse             ; can't mirror gitlab commit
    # forge                 ; workround yaml-mode hanging infinitely
    # gcmh                  ; can't mirror gitlab commit
    # git-timemachine       ; can't mirror gitlab commit
    # highlight-parentheses ; can't mirror git.sr.ht
    # lsp-java              ; bad hash on dependency bui-mode
    # paredit               ; can't mirror mumble.net git
    # ron-mode              ; can't mirror codeberg.org
    # salt-mode             ; workround yaml-mode hanging infinitely
    # yaml-mode             ; workround yaml-mode hanging infinitely

    ac-ispell
    ace-jump-mode
    ace-link
    ace-window
    adoc-mode
    aggressive-indent
    alert
    all-the-icons
    alsamixer
    anaphora
    annalist
    ansible
    ansible-doc
    anzu
    async
    attrap
    auto-compile
    auto-complete
    auto-dictionary
    auto-highlight-symbol
    auto-yasnippet
    autothemer
    avy
    bind-key
    bind-map
    blacken
    browse-at-remote
    bundler
    cargo
    ccls
    centered-cursor-mode
    chruby
    clang-format
    clean-aindent-mode
    closql
    cmm-mode
    column-enforce-mode
    company
    company-ansible
    company-c-headers
    company-cabal
    company-emacs-eclim
    company-go
    company-lua
    company-nixos-options
    company-php
    company-plsense
    company-quickhelp
    company-restclient
    company-shell
    company-statistics
    company-terraform
    company-web
    concurrent
    consult
    consult-yasnippet
    copy-as-format
    counsel
    counsel-gtags
    counsel-projectile
    cpp-auto-include
    cquery
    ctable
    cython-mode
    dactyl-mode
    dante
    deferred
    define-word
    devdocs
    diff-hl
    diminish
    direnv
    disaster
    docker
    docker-tramp
    dockerfile-mode
    doom-modeline
    dotenv-mode
    drag-stuff
    dumb-jump
    eclim
    editorconfig
    ein
    eldoc-eval
    elfeed
    elfeed-goodies
    elfeed-org
    elfeed-web
    elisp-slime-nav
    emacsql
    emacsql-sqlite
    embark
    embark-consult
    emmet-mode
    engine-mode
    ep.csv-mode
    ep.elpaPackages.xclip
    ep.font-lock-plus
    ep.mmm-mode
    ep.orgPackages.org
    ep.orgPackages.org-plus-contrib
    ep.rtags
    ep.sql-indent
    ep.undo-tree
    epc
    epl
    esh-help
    eshell-prompt-extras
    eshell-z
    eval-sexp-fu
    evil
    evil-anzu
    evil-args
    evil-easymotion
    evil-ediff
    evil-exchange
    evil-goggles
    evil-iedit-state
    evil-indent-plus
    evil-ledger
    evil-lion
    evil-lisp-state
    evil-matchit
    evil-mc
    evil-nerd-commenter
    evil-numbers
    evil-org
    evil-surround
    evil-textobj-line
    evil-tutor
    evil-visual-mark-mode
    evil-visualstar
    exec-path-from-shell
    expand-region
    f
    fancy-battery
    fill-column-indicator
    fish-mode
    flx
    flx-ido
    flycheck
    flycheck-bashate
    flycheck-elsa
    flycheck-haskell
    flycheck-ledger
    flycheck-package
    flycheck-pos-tip
    flycheck-rust
    flyspell-correct
    fringe-helper
    fuzzy
    ggtags
    gh
    gh-md
    ghub
    gist
    git-commit
    git-gutter
    git-gutter-fringe
    git-link
    git-messenger
    git-modes
    github-clone
    github-search
    gitignore-templates
    gntp
    gnuplot-mode
    go-eldoc
    go-fill-struct
    go-gen-test
    go-guru
    go-impl
    go-mode
    go-rename
    go-tag
    godoctor
    golden-ratio
    google-c-style
    google-translate
    goto-chg
    gradle-mode
    graphviz-dot-mode
    grip-mode
    groovy-imports
    groovy-mode
    gruvbox-theme
    haml-mode
    haskell-mode
    haskell-snippets
    hcl-mode
    hierarchy
    highlight
    highlight-indentation
    highlight-numbers
    hl-todo
    hlint-refactor
    ht
    htmlize
    hungry-delete
    hydra
    ibuffer-projectile
    iedit
    imenu-list
    impatient-mode
    importmagic
    indent-guide
    inf-ruby
    insert-shebang
    ivy
    jenkins
    jinja2-mode
    js-doc
    js2-mode
    js2-refactor
    json-mode
    json-navigator
    json-reformat
    json-snatcher
    jupyter
    know-your-http-well
    language-detection
    lcr
    ledger-mode
    link-hint
    list-utils
    live-py-mode
    livid-mode
    log4e
    logito
    lorem-ipsum
    lsp-haskell
    lsp-mode
    lsp-origami
    lsp-pyright
    lsp-ui
    lua-mode
    macrostep
    magit
    magit-gitflow
    magit-popup
    magit-section
    magit-svn
    marginalia
    markdown-mode
    markdown-toc
    markup-faces
    marshal
    maven-test-mode
    meghanada
    memoize
    minitest
    mmm-jinja2
    move-text
    multi-line
    multi-term
    multiple-cursors
    mvn
    mwim
    nameless
    names
    nginx-mode
    nix-mode
    nix-update
    nixos-options
    nodejs-repl
    noflet
    ob-http
    ob-restclient
    open-junk-file
    orderless
    org-bookmark-heading
    org-brain
    org-bullets
    org-category-capture
    org-cliplink
    org-download
    org-jira
    org-journal
    org-mime
    org-mru-clock
    org-pomodoro
    org-present
    org-projectile
    org-rich-yank
    org-roam
    org-super-agenda
    org-superstar
    orgit
    origami
    overseer
    ox-gfm
    ox-jira
    ox-pandoc
    ox-twbs
    p4
    package-lint
    packed
    pandoc-mode
    paradox
    parent-mode
    password-generator
    pcache
    pcre2el
    pdf-tools
    persp-mode
    pfuture
    pip-requirements
    pipenv
    pippel
    pkg-info
    poetry
    polymode
    popper
    popup
    popwin
    pos-tip
    powerline
    prettier-js
    projectile
    pug-mode
    py-isort
    pydoc
    pyenv-mode
    pytest
    pythonic
    pyvenv
    quickrun
    racer
    rainbow-delimiters
    rake
    rbenv
    request
    request-deferred
    restart-emacs
    restclient
    ripgrep
    robe
    rpm-spec-mode
    rspec-mode
    rubocop
    rubocopfmt
    ruby-hash-syntax
    ruby-refactor
    ruby-test-mode
    ruby-tools
    rvm
    s
    sass-mode
    sbt-mode
    scala-mode
    scss-mode
    seeing-is-believing
    shell-pop
    shrink-path
    shut-up
    simple-httpd
    skewer-mode
    slim-mode
    smartparens
    smeargle
    solarized-theme
    spaceline
    spaceline-all-the-icons
    sphinx-doc
    string-edit
    string-inflection
    swiper
    symbol-overlay
    symon
    systemd
    tablist
    tagedit
    terminal-here
    tern
    terraform-mode
    tmux-pane
    toc-org
    toml-mode
    treepy
    unfill
    use-package
    uuidgen
    vi-tilde-fringe
    vimrc-mode
    visual-fill-column
    volatile-highlights
    vterm
    web-beautify
    web-completion-data
    web-mode
    websocket
    wgrep
    which-key
    window-purpose
    winum
    with-editor
    writeroom-mode
    ws-butler
    xcscope
    xml-rpc
    xterm-color
    yapfify
    yasnippet
    yasnippet-snippets
    zeal-at-point
  ];

  # Many emacs packages may pull in dependencies on things they need
  # automatically, but for those that don't, here are the requisite NixPkgs. Nix
  # will wrap these into a buildEnv dir, and then add it to the wrapped emacs'
  # `exec-path` variable so that they're accessible inside emacs.
  myEmacsDeps = [
    # General tools
    self.direnv # For direnv-mode
    self.ripgrep # For vertico

    # C/C++ Tools
    self.clang-tools

    # Python Tools
    self.autoflake
    self.python3Packages.pyflakes

    # Rust Tools
    self.cargo
    self.rustc
    self.rustfmt

    # LSP Tools
    self.nodePackages.bash-language-server
    self.nodePackages.pyright
    self.nodePackages.vscode-json-languageserver
  ];

  # Build a spacemacs with the pinned overlay import, using the passed emacs
  mkSpacemacs = package:
    self.emacsWithPackagesFromUsePackage {
      config = "";
      inherit package;
      extraEmacsPackages = ep: ((myEmacsPkgs ep) ++ myEmacsDeps);
    };

  spacemacsGcc = mkSpacemacs self.emacsGcc;
  spacemacsGit = mkSpacemacs self.emacsGit;
  spacemacs = spacemacsGcc;

in
{
  inherit spacemacsGcc spacemacsGit spacemacs;
}
