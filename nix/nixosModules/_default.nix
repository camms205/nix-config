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
  imports = [
    inputs.disko.nixosModules.disko
  ] ++ builtins.attrValues (builtins.removeAttrs inputs.self.nixosModules [ "default" ]);

  options.camms.default.enable = mkEnableOption "Default options" // {
    default = true;
  };

  config = mkIf cfg.enable {
    # services.automatic-timezoned.enable = true;

    programs.fish.enable = true;
  };
}
