{
  lib,
  pkgs,
  inputs,
  config,
  ...
}:
let
  cfg = config.camms.wsl;
in
with lib;
{
  imports = [ inputs.nixos-wsl.nixosModules.default ];

  options.camms.wsl.enable = mkEnableOption "wsl";

  config = mkIf cfg.enable {
    wsl = {
      enable = true;
      defaultUser = config.camms.user.name;
      useWindowsDriver = true;
    };

    services.resolved.enable = false;
  };
}
