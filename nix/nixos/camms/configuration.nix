{
  lib,
  pkgs,
  inputs,
  config,
  modulesPath,
  ...
}:
with lib;
{
  imports = [
    ./disko.nix
    inputs.self.nixosModules.default
  ];

  fileSystems."/nix/persist".neededForBoot = true;

  camms = {
    archetypes.server.enable = true;
    facter = {
      enable = true;
      path = ./facter.json;
    };
    home.enable = true;
    home.path = ./home.nix;
    impermanence.enable = true;
    user.name = "cameron";
  };

  networking = {
    hostName = "camms";
    hostId = "707378ff";
  };

  boot = {
    initrd = {
      availableKernelModules = [ "virtio_scsi" ];
      systemd.enable = true;
    };
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  services.adguardhome.enable = true;

  environment.systemPackages = with pkgs; [
    curl
    vim
  ];

  documentation.man.generateCaches = false;

  system.stateVersion = "24.05";
}
