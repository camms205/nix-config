{
  inputs,
  pkgs,
  config,
  ...
}:
{
  imports = [
    inputs.self.nixosModules.default
    inputs.determinate.nixosModules.default
  ];

  camms = {
    suites.common.enable = true;
    home.enable = true;
    home.path = ./home.nix;
    impermanence.enable = true;
    user.name = "cameron";
    wsl.enable = true;
  };

  networking.hostName = "learn21";

  environment.systemPackages = with pkgs; [
    curl
    vim
  ];

  system.stateVersion = "24.05";
}
