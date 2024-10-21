{
  lib,
  pkgs,
  inputs,
  config,
  ...
}:
let
  cfg = config.camms.default;
in
with lib;
{
  imports = builtins.attrValues (builtins.removeAttrs inputs.self.homeModules [ "default" ]);

  options.camms.default.enable = mkOption {
    type = types.bool;
    description = "Default options";
    default = true;
  };

  config = {
    camms = mkIf cfg.enable {
      sh.enable = mkDefault true;
      helix.enable = mkDefault true;
      stylix.enable = mkDefault true;
    };
    home.stateVersion = "24.05";
    fonts.fontconfig.enable = true;
  };
}
