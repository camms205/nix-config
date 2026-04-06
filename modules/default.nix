{ __findFile, lib, ... }:
{
  flake-file.inputs = {
    disko.url = "github:nix-community/disko";
    home-manager.url = "github:nix-community/home-manager";
    nixos-facter-modules.url = "github:numtide/nixos-facter-modules";
  };

  den.default = {
    includes = [
      <den/define-user>
      <den/hostname>
    ];

    nixos.system.stateVersion = lib.mkDefault "24.05";
    homeManager.home.stateVersion = lib.mkDefault "24.05";
  };

  den.aspects.cameron = {
    includes = [
      <den/primary-user>
      (<den/user-shell> "fish")
    ];
  };

  den.schema.user.classes = lib.mkDefault [ "homeManager" ];
}
