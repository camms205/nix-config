{
  lib,
  pkgs,
  inputs,
  config,
  ...
}:
let
  cfg = config.camms.facter;
in
with lib;
{
  imports = [ inputs.nixos-facter-modules.nixosModules.facter ];

  options.camms.facter = {
    enable = mkEnableOption "facter";
    path = mkOption {
      type = types.path;
    };
  };

  config = mkIf cfg.enable {
    facter.reportPath = cfg.path;
  };
}
