{
  lib,
  pkgs,
  inputs,
  config,
  ...
}:
let
  cfg = config.camms.suites.desktop;
in
with lib;
{
  options.camms.suites.desktop.enable = mkEnableOption "desktop suite";

  config = mkIf cfg.enable {
    camms = {
      home.enable = mkDefault true;
      impermanence.enable = mkDefault true;
      services.keyd.enable = mkDefault true;
      stylix.enable = mkDefault true;
    };
  };
}
