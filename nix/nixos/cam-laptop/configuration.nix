{
  lib,
  pkgs,
  inputs,
  config,
  ...
}:
with lib;
let
  user = "cameron";
in
{
  imports = [
    ./hardware-configuration.nix
    inputs.self.nixosModules.default
  ];

  camms = {
    archetypes.workstation.enable = true;
    home.path = ./home.nix;
    user.extraGroups = [
      "networkmanager"
      "libvirtd"
    ];
    variables = {
      username = "${user}";
      ewwDir = ./eww;
      flakeDir = "/home/cameron/dotfiles/nix";
    };
  };

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    binfmt.emulatedSystems = [ "aarch64-linux" ];
  };
  nix.settings.extra-platforms = config.boot.binfmt.emulatedSystems;

  networking.hostName = "cam-laptop";
  networking.networkmanager.enable = true;
  networking.iproute2.enable = true;

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
    dconf.enable = true;
    nm-applet.enable = true;
    steam.enable = true;
    virt-manager.enable = true;
  };

  virtualisation.libvirtd.enable = true;

  environment.systemPackages = with pkgs; [
    adwaita-icon-theme
    brightnessctl
    git
    helvum
    iproute2
    socat
    sshfs
    vim
    wget
    xfce.xfce4-icon-theme
  ];
  fonts.packages = with pkgs; [
    corefonts
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    fira-code-nerdfont
  ];

  security.rtkit.enable = true;
  services = {
    blueman.enable = true;
    fwupd.enable = true;
    logrotate.checkConfig = false;
    openssh.enable = true;
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

  environment.variables = {
    POLKIT_BIN = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
  };

  system.stateVersion = "24.05";
}
