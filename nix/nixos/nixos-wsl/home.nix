{
  lib,
  pkgs,
  inputs,
  ...
}:
with lib;
{
  home.packages = with pkgs; [
    distrobox
    tigervnc
    waypipe
    moonlight-qt
  ];

  services = {
    dunst.enable = true;
    syncthing.enable = true;
  };

  programs = {
    home-manager.enable = true;
    fish.enable = true;
    nix-index.enable = true;
    nushell.enable = true;
    starship.enable = true;
  };
}
