{
  lib,
  inputs,
  config,
  ...
}:
{
  flake-file.inputs = {
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  camms.sops.nixos = {
    imports = [ inputs.sops-nix.nixosModules.sops ];

    sops = {
      defaultSopsFile = "${inputs.self}/secrets/default.yaml";
      secrets = {
        "copilot_api_key".owner = "cameron";
        "spotify_user".owner = "cameron";
        "spotify_pass".owner = "cameron";
      };
      age = {
        sshKeyPaths = [ "/nix/persist/etc/ssh/ssh_host_ed25519_key" ];
      };
    };
  };
}
