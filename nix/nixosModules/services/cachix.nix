{
  lib,
  pkgs,
  inputs,
  config,
  ...
}:
let
  cfg = config.camms.services.cachix;
in
with lib;
{
  options.camms.services.cachix.enable = mkEnableOption "cachix";

  config = mkIf cfg.enable {
    services.cachix-agent.enable = true;

    sops.secrets = {
      "cachix-agent".path = "/etc/cachix-agent.token";
      "cachix".owner = "${config.camms.user.name}";
    };
    environment.systemPackages = [
      pkgs.cachix
    ];
  };
}
