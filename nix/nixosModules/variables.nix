{
  lib,
  config,
  ...
}:
let
  cfg = config.camms.variables;
in
with lib;
{
  options.camms.variables = {
    flakeDir = mkOption {
      type = types.str;
      default = "/home/${cfg.username}/.config/nixos/";
    };
    ewwDir = mkOption {
      type = types.nullOr types.path;
      default = null;
    };
  };
}
