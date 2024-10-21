{
  description = "NixOS system";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flakelight.url = "github:nix-community/flakelight";
    flakelight.inputs.nixpkgs.follows = "nixpkgs";

    nixos-facter-modules.url = "github:numtide/nixos-facter-modules";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    impermanence.url = "github:nix-community/impermanence";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";

    stylix.url = "github:danth/stylix";
    stylix.inputs = {
      home-manager.follows = "home-manager";
      nixpkgs.follows = "nixpkgs";
    };

    poetry2nix.url = "github:nix-community/poetry2nix";
    poetry2nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    { flakelight, ... }@inputs:
    flakelight ./. (
      { outputs, ... }@flake:
      {
        inherit inputs;
        withOverlays = [
          inputs.poetry2nix.overlays.default
          (_: _: { inherit (outputs) nixosConfigurations; })
        ];
      }
    );
}
