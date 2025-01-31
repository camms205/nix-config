{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.camms.spotify;
in
with lib;
{
  options.camms.spotify.enable = mkEnableOption "spotify";

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.spotify-player
    ];

    services.spotifyd = {
      enable = true;
      settings = {
        global = {
          cache_path = "${config.home.homeDirectory}/.cache/spotifyd";
          username_cmd = "cat /run/secrets/spotify_user";
          # password_cmd = "cat /run/secrets/spotify_pass";
          backend = "pulseaudio";
          device_name = "cam-desktop";
          device_type = "computer";
        };
      };
    };
  };
}
