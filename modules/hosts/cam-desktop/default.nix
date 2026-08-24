{
  camms,
  inputs,
  den,
  ...
}:
{
  den.aspects.cam-desktop = {
    includes = [
      camms.hyprland
      camms.gaming
      camms.ghostty
      camms.systemd-boot
      (den.batteries.unfree [ "corefonts" ])
      camms.keyd
      camms.cachix
      camms.ssh
      camms.tailscale
      camms.impermanence
      camms.sops
    ];

    nixos = { config, pkgs, ... }: {
      imports = [
        ./_disko.nix
        inputs.determinate.nixosModules.default
        inputs.disko.nixosModules.disko
        inputs.nixos-facter-modules.nixosModules.facter
      ];

      facter.reportPath = ./facter.json;

      boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
      nix.settings.extra-platforms = config.boot.binfmt.emulatedSystems;

      i18n.inputMethod = {
        enable = true;
        type = "fcitx5";
        fcitx5 = {
          addons = with pkgs; [
            fcitx5-mozc
            fcitx5-gtk
          ];
          waylandFrontend = true;
        };
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
      };

      environment.systemPackages = with pkgs; [
        adwaita-icon-theme
        brightnessctl
        distrobox
        crosspipe
        vim
        xfce4-icon-theme
      ];
      fonts.packages = with pkgs; [
        corefonts
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-color-emoji
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
    };
  };
}
