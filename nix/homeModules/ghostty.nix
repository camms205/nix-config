{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
let
  cfg = config.camms.ghostty;
in
with lib;
{
  options.camms.ghostty.enable = mkEnableOption "ghostty";

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.ghostty
    ];

    xdg.configFile."ghostty/config".text = ''
      theme = catppuccin-mocha
      font-family = FiraCode Nerd Font
      window-decoration = false
    '';
  };
}
