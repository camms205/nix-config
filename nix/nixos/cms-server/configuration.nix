{
  inputs,
  pkgs,
  config,
  ...
}:
{
  imports = [
    ./disko.nix
    inputs.self.nixosModules.default
  ];

  camms = {
    archetypes.server.enable = true;
    facter = {
      enable = true;
      path = ./facter.json;
    };
    home.enable = true;
    home.path = ./home.nix;
    impermanence.enable = true;
    services.arrs.enable = true;
    user.name = "cameron";
  };

  services = {
    xserver.videoDrivers = [ "nvidia" ];
    logind = {
      lidSwitch = "ignore";
      lidSwitchDocked = "ignore";
    };
  };

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
  };

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  nix.settings.extra-platforms = config.boot.binfmt.emulatedSystems;

  networking.hostName = "cms-server";

  environment.systemPackages = with pkgs; [
    curl
    vim
  ];

  system.stateVersion = "24.05";
}
