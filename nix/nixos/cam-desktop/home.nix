{
  lib,
  pkgs,
  ...
}:
with lib;
{
  camms = {
    browser.enable = true;
    hyprland.enable = true;
    programs.enable = true;
  };
}
