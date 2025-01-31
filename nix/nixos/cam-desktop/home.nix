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
}
