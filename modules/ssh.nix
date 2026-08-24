{ ... }:
{
  camms.ssh.nixos = {
    services.openssh.enable = true;
    sops.secrets = {
      "cameron_ssh_key".owner = "cameron";
    };
  };
}
