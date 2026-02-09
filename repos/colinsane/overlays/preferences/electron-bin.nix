_self: super:
let
  # XXX(2024-12-26 - 2025-08-07): prefer pre-built electron because otherwise it takes 4 hrs to build from source.
  # but wait 2 days after staging -> master merge, and normal electron should be cached and safe to remove
  maxVersion = 99;
  versions = super.lib.range 1 maxVersion;
  electronName = v: "electron_${toString v}";
  electronOverrides = builtins.foldl' (acc: name: acc // super.lib.optionalAttrs (super ? "${name}-bin") {
    "${name}" = super."${name}-bin";
  }) {} (map electronName versions);
in
  super.lib.throwIf
    (super ? "${electronName (maxVersion+1)}")
    "electron has updated past ${toString maxVersion}: bump maxVersion to continue using electron-bin"
    electronOverrides
