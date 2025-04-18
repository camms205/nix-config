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
    ./disko.nix
    inputs.self.nixosModules.default
  ];

  facter.reportPath = ./facter.json;

  camms = {
    facter = {
      enable = true;
      path = ./facter.json;
    };
    archetypes.workstation.enable = true;
    home.path = ./home.nix;
    user = {
      name = user;
      extraGroups = [
        "libvirtd"
        "dialout"
        "podman"
      ];
    };
    variables = {
      ewwDir = ./eww;
      flakeDir = "/home/cameron/.dotfiles/nix";
    };
  };

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  nix.settings.extra-platforms = config.boot.binfmt.emulatedSystems;

  networking = {
    hostName = "cam-desktop";
    hostId = "ed222780";
    networkmanager.unmanaged = [ "interface-name:ve-*" ];
    nat = {
      enable = true;
      internalInterfaces = [ "ve-+" ];
      externalInterface = "enp14s0";
    };
  };

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
    coolercontrol.enable = true;
    gnome-terminal.enable = true;
    dconf.enable = true;
    nm-applet.enable = true;
    steam = {
      enable = true;
      extraCompatPackages = with pkgs; [ proton-ge-bin ];
      gamescopeSession.enable = true;
      gamescopeSession.args = [
        "--hdr-enabled"
        "--adaptive-sync"
      ];
    };
    virt-manager.enable = true;
  };

  virtualisation = {
    spiceUSBRedirection.enable = true;
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
      };
    };
    containers.enable = true;
  };

  environment.systemPackages = with pkgs; [
    brightnessctl
    dive
    distrobox
    adwaita-icon-theme
    helvum
    podman-compose
    podman-tui
    vim
    virtiofsd
    xfce.xfce4-icon-theme
  ];
  fonts.packages = with pkgs; [
    corefonts
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    nerd-fonts.fira-code
  ];

  security = {
    rtkit.enable = true;
    pam.services = {
      login.u2fAuth = true;
      sudo.u2fAuth = true;
    };
  };
  services = {
    avahi.enable = true;
    blueman.enable = true;
    flatpak.enable = true;
    fwupd.enable = true;
    logrotate.checkConfig = false;
    pcscd.enable = true;
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
    ratbagd.enable = true;
    sunshine = {
      enable = true;
      capSysAdmin = true;
    };
    udev.packages = [ pkgs.yubikey-personalization ];
  };

  system.stateVersion = "24.05";
}
