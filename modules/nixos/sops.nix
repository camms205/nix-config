{
  flake,
  lib,
  pkgs,
  inputs,
  config,
  ...
}:
let
  cfg = config.camms.sops;
  imp = config.camms.impermanence;
in
with lib;
with flake.lib;
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  options.camms.sops = {
    enable = mkEnableOption "sops";
    sshKeyPaths = mkOption {
      type = with types; listOf str;
      default = [ "/etc/ssh/ssh_host_ed25519_key" ];
    };
    defaultSopsFile = mkOption {
      type = types.path;
      default = "${inputs.self}/secrets/default.yaml";
    };
    keyFile = mkOption {
      type = types.nullOr types.str;
      default = null;
    };
  };

  config = mkIf cfg.enable {
    sops = {
      inherit (cfg) defaultSopsFile;
      age = {
        inherit (cfg) sshKeyPaths;
        keyFile = mkIf (cfg.keyFile != null) cfg.keyFile;
      };
    };
  };
}
