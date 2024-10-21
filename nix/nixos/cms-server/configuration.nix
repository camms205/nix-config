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
    impermanence.enable = true;
    user.name = "cameron";
  };
}
