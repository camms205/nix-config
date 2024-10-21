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

  config.programs = mkIf cfg.enable {
    chromium = {
      enable = true;
      package = pkgs.brave;
      commandLineArgs = [
        "--enable-features=UseOzonePlatform"
        "--ozone-platform=wayland"
        "--gtk-version=4"
      ];
    };
    firefox = {
      enable = true;
    };
  };
}
