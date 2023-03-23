{ defaultBranch ? "main"
, signingKey ? "F90110C7"
, userName ? "P. R. d. O."
, userEmail ? "d.ol.rod@tutanota.com"
}:

{
  programs.git = {
    enable = true;
    extraConfig.init.defaultBranch = defaultBranch;
    signing = {
      key = signingKey;
      signByDefault = true;
    };
    userName = userName;
    userEmail = userEmail;
  };
}