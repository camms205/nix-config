{
  lib,
  pkgs,
  ...
}:
with lib;
{
  camms = {
    # niri.enable = true;
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
