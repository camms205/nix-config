{
  lib,
  pkgs,
  inputs,
  config,
  ...
}:
let
  cfg = config.camms.services.tailscale;
in
with lib;
{
  options.camms.services.tailscale.enable = mkEnableOption "tailscale";

  config = mkIf cfg.enable {
    services.tailscale = {
      enable = true;
      authKeyFile = config.sops.secrets.tailscale.path;
      useRoutingFeatures = "both";
    };

    sops.secrets."tailscale" = { };
  };
}
