{
  lib,
  pkgs,
  ...
}:
with lib;
{
  camms = {
    hyprland = {
      enable = true;
      hdr = true;
    };
  };

  services = {
    dunst.settings.global.monitor = 1;
  };

  home.packages = with pkgs; [
    blender-hip
    zoom-us
  ];
}
