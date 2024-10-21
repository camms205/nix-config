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
    services.arrs.enable = true;
    user.extraGroups = [
      "networkmanager"
      "libvirtd"
      "dialout"
      "podman"
    ];
    variables = {
      username = "${user}";
      ewwDir = ./eww;
      flakeDir = "/home/cameron/.dotfiles/nix";
    };
  };

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    supportedFilesystems = [
      "btrfs"
      "zfs"
    ];
    zfs.forceImportRoot = false;
    binfmt.emulatedSystems = [ "aarch64-linux" ];
  };
  nix.settings.extra-platforms = config.boot.binfmt.emulatedSystems;

  networking = {
    hostName = "cam-desktop";
    hostId = "ed222780";
    networkmanager = {
      enable = true;
      unmanaged = [ "interface-name:ve-*" ];
    };
    iproute2.enable = true;
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
    coolercontrol.enable = true;
    gnome-terminal.enable = true;
    dconf.enable = true;
    nm-applet.enable = true;
    steam.enable = true;
    virt-manager.enable = true;
  };

  virtualisation = {
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
    git
    helvum
    iproute2
    podman-compose
    podman-tui
    socat
    sshfs
    vim
    virtiofsd
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
    avahi.enable = true;
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
    ratbagd.enable = true;
    sunshine = {
      enable = true;
      capSysAdmin = true;
    };
  };

  environment.variables = {
    POLKIT_BIN = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
  };

  system.stateVersion = "24.05";
}
