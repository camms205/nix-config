{
  lib,
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ./disko.nix
    inputs.self.nixosModules.default
  ];

  camms = {
    archetypes.server.enable = true;
    facter = {
      enable = true;
      path = ./facter.json;
    };
    home.enable = true;
    home.path = ./home.nix;
    impermanence.enable = true;
    user.name = "cameron";
  };

  networking.hostName = "cms-server";

  environment.systemPackages = with pkgs; [
    curl
    vim
  ];

  system.stateVersion = "24.05";
}
