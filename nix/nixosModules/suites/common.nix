{ lib, config, ... }:
let
  cfg = config.camms.suites.common;
in
with lib;
{
  options.camms.suites.common.enable = mkEnableOption "desktop suite";

  config = mkIf cfg.enable {
    camms = {
      nix.enable = mkDefault true;
      services = {
        cachix.enable = mkDefault true;
        ssh.enable = mkDefault true;
        tailscale.enable = mkDefault true;
      };
      user.enable = mkDefault true;
    };
  };
}
