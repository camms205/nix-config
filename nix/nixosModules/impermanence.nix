{
  lib,
  pkgs,
  inputs,
  config,
  ...
}:
let
  cfg = config.camms.impermanence;
in
with lib;
{
  imports = [ inputs.impermanence.nixosModules.impermanence ];

  options.camms.impermanence = {
    enable = mkEnableOption "impermanence";
    path = mkOption {
      type = types.str;
      default = "/nix/persist";
    };
  };
  config.environment.persistence.${cfg.path} = mkIf cfg.enable {
    hideMounts = true;
    directories = [
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/etc/NetworkManager/system-connections"
    ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
    ];
  };

}
