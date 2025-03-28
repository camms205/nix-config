{
  lib,
  pkgs,
  inputs,
  config,
  ...
}:
let
  cfg = config.camms.programs;
in
with lib;
{
  options.camms.programs.enable = mkEnableOption "programs";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # blender-hip
      discord
      jellyfin-media-player
      libreoffice
      kdePackages.okular
      prismlauncher
      wineWowPackages.stable
    ];

    programs = {
      kitty.enable = true;
      zathura.enable = true;
    };

    services = {
      dunst.enable = true;
      easyeffects.enable = true;
      syncthing.enable = true;
    };
  };
}
