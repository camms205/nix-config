{
  lib,
  pkgs,
  inputs,
  config,
  ...
}:
let
  cfg = config.camms.nix;
in
with lib;
{
  options.camms.nix.enable = mkEnableOption "nix settings";

  config = mkIf cfg.enable {
    nix = {
      settings = {
        auto-optimise-store = true;
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        trusted-users = [
          "@wheel"
        ];
        substituters = [
          "https://cache.garnix.io"
          "https://nixpkgs-unfree.cachix.org"
          "https://nix-community.cachix.org"
          "https://darknebula05.cachix.org"
        ];
        trusted-public-keys = [
          "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
          "nixpkgs-unfree.cachix.org-1:hqvoInulhbV4nJ9yJOEr+4wxhDV4xq2d1DK7S6Nj6rs="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "darknebula05.cachix.org-1:DYYMiJaS92u6Iz/pXpuLlGqfqp4iR/WO535nBUnvxhU="
        ];
      };
      nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
    };

    nixpkgs = {
      config.allowUnfree = true;
      overlays = [
        (final: prev: {
          inherit (inputs.self.packages.${prev.stdenv.hostPlatform.system}) riven riven-frontend zurg;
        })
      ];
    };

    programs.nh = {
      enable = true;
      clean = {
        enable = true;
        extraArgs = "--keep-since 4d --keep 3 --nogcroots";
      };
      flake = config.camms.variables.flakeDir;
    };
  };
}
