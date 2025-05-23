{
  lib,
  pkgs,
  inputs,
  config,
  ...
}:
with lib;
{
  imports = [
    ./hardware-configuration.nix
    inputs.self.nixosModules.default
  ];

  camms = {
    archetypes.workstation.enable = true;
    home.path = ./home.nix;
    user.extraGroups = [
      "libvirtd"
    ];
    user.name = "cameron";
    variables = {
      ewwDir = ./eww;
      flakeDir = "/home/cameron/dotfiles/nix";
    };
  };

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  nix.settings.extra-platforms = config.boot.binfmt.emulatedSystems;

  networking.hostName = "cam-laptop";

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-mozc
      fcitx5-gtk
    ];
  };

  time.timeZone = "America/New_York";
  hardware = {
    bluetooth.enable = true;
    graphics.enable = true;
  };

  programs = {
    hyprland = {
      enable = true;
      withUWSM = true;
    };
    uwsm.enable = true;
    dconf.enable = true;
    nm-applet.enable = true;
    steam = {
      enable = true;
      extraCompatPackages = with pkgs; [ proton-ge-bin ];
    };
    virt-manager.enable = true;
  };

  virtualisation.libvirtd.enable = true;

  environment.systemPackages = with pkgs; [
    adwaita-icon-theme
    brightnessctl
    helvum
    vim
    xfce.xfce4-icon-theme
  ];
  fonts.packages = with pkgs; [
    corefonts
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    nerd-fonts.fira-code
  ];

  security.rtkit.enable = true;
  services = {
    blueman.enable = true;
    fprintd.enable = true;
    fwupd.enable = true;
    logrotate.checkConfig = false;
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;
    };
    printing.enable = true;
  };

  system.stateVersion = "24.05";
}
