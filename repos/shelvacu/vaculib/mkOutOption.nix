{ lib, ... }:
{
  mkOutOption =
    val:
    lib.mkOption {
      readOnly = true;
      default = val;
      defaultText = "(final/output of module)";
    };
}
