{ lib, config, ... }:
let
  cfg = config.camms.services.ssh;
in
with lib;
{
  options.camms.services.ssh = {
    enable = mkEnableOption "ssh";
  };

  config = mkIf cfg.enable {
    services.openssh.enable = true;
  };
}
