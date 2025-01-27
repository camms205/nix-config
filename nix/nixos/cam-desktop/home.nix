{
  lib,
  pkgs,
  ...
}:
with lib;
{
  camms = {
    browser.enable = true;
    hyprland = {
      enable = true;
      hdr = true;
    };
    programs.enable = true;
    ghostty.enable = true;
  };
}
