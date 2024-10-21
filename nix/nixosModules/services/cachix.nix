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

  config = {
    services.cachix-agent.enable = mkIf cfg.enable true;
  };
}
