{ ... }:
{
  camms.cachix.nixos = { pkgs, ... }: {
    services.cachix-agent.enable = true;

    sops.secrets = {
      "cachix-agent".path = "/etc/cachix-agent.token";
      "cachix".owner = "cameron";
    };
    environment.systemPackages = [
      pkgs.cachix
    ];
  };
}
