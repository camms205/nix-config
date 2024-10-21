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

  config.wsl = mkIf cfg.enable {
    enable = true;
    defaultUser = config.camms.variables.username;
    useWindowsDriver = true;
  };
}
