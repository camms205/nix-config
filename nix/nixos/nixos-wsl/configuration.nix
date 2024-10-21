{
  lib,
  pkgs,
  inputs,
  config,
  ...
}:
with lib;
{
  imports = [ inputs.self.nixosModules.default ];

  camms = {
    facter = {
      enable = true;
      path = ./facter.json;
    };
    home.enable = true;
    home.path = ./home.nix;
    suites.common.enable = true;
    wsl.enable = true;
    stylix.enable = true;
    variables = {
      username = "cshearer";
      flakeDir = "/home/cshearer/dotfiles/nix";
    };
  };

  system.stateVersion = "24.05";

  programs = {
    nix-ld.enable = true;
  };

  networking.hostName = "nixos-wsl";

  fonts.packages = with pkgs; [ fira-code-nerdfont ];

  services = {
    avahi.enable = true;
    openssh.enable = true;
  };
}
