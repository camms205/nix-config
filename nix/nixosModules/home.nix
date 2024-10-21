{
  lib,
  pkgs,
  inputs,
  config,
  ...
}:
let
  cfg = config.camms.home;
in
with lib;
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.camms.home = {
    enable = mkEnableOption "home";
    name = mkOption {
      type = types.str;
      default = config.camms.variables.username;
    };
    path = mkOption {
      type = types.nullOr types.path;
      default = null;
    };
  };

  config.home-manager = mkIf cfg.enable {
    useUserPackages = true;
    useGlobalPkgs = true;
    users.${cfg.name} = mkIf (cfg.path != null) cfg.path;
    sharedModules = [ inputs.self.homeModules.default ];
    extraSpecialArgs = {
      inherit inputs;
    };
  };
}
