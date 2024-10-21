{ lib, config, ... }:
let
  cfg = config.camms.systemd-boot;
in
with lib;
{
  options.camms.systemd-boot.enable = mkEnableOption "systemd-boot";

  config.boot = mkIf cfg.enable {
    initrd.systemd.enable = true;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };
}
