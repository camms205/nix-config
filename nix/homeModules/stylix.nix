{
  lib,
  pkgs,
  inputs,
  config,
  ...
}:
let
  cfg = config.camms.stylix;
in
with lib;
{
  options.camms.stylix.enable = mkEnableOption "stylix";

  config = mkIf cfg.enable {
    gtk = {
      enable = true;
      iconTheme = {
        package = pkgs.adwaita-icon-theme;
        name = "Adwaita";
      };
    };
    qt.enable = true;
  };
}
