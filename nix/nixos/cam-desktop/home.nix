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

  home.packages = with pkgs; [
    blender-hip
    zoom-us
  ];
}
