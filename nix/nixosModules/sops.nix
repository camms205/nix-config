{
  lib,
  inputs,
  config,
  ...
}:
let
  cfg = config.camms.sops;
  imp = config.camms.impermanence;
in
with lib;
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  options.camms.sops = {
    sshKeyPaths = mkOption {
      type = with types; listOf str;
      default =
        let
          prefix = (if imp.enable then imp.path else "");
        in
        [ "${prefix}/etc/ssh/ssh_host_ed25519_key" ];
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

  config = {
    sops = {
      inherit (cfg) defaultSopsFile;
      secrets = {
        "copilot_api_key".owner = "${config.camms.user.name}";
        "spotify_user".owner = "${config.camms.user.name}";
        "spotify_pass".owner = "${config.camms.user.name}";
      };
      age = {
        inherit (cfg) sshKeyPaths;
        keyFile = mkIf (cfg.keyFile != null) cfg.keyFile;
      };
    };
  };
}
