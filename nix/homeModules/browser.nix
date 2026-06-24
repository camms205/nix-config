{
  lib,
  pkgs,
  inputs,
  config,
  ...
}:
let
  cfg = config.camms.browser;
in
with lib;
{
  options.camms.browser.enable = mkEnableOption "browsers";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      brave
    ];

    programs = mkIf false {
      chromium = {
        enable = true;
        package = pkgs.brave;
        commandLineArgs = [
          "--enable-features=UseOzonePlatform"
          "--ozone-platform=wayland"
          "--gtk-version=4"
        ];
      };
    };
  };
}
