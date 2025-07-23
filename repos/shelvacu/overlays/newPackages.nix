let
  newPackagePaths = import ../packages;
in
self: _super: builtins.mapAttrs (_: path: self.callPackage path { }) newPackagePaths
