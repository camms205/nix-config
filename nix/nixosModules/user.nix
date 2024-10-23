{
  lib,
  pkgs,
  inputs,
  config,
  ...
}:
let
  cfg = config.camms.user;
  sops = config.camms.sops.enable;
in
with lib;
{
  options.camms.user = {
    enable = mkEnableOption "user";
    name = mkOption {
      type = types.str;
    };
    admin = mkOption {
      type = types.bool;
      default = true;
    };
    extraGroups = mkOption {
      type = types.listOf types.str;
      default = [ ];
    };
    hashedPasswordFile = mkOption {
      type = types.str;
    };
    defaultUserShell = mkOption {
      type = types.package;
      default = pkgs.fish;
    };
  };

  config = mkIf cfg.enable {
    users =
      let
        keys = mapAttrsToList (file: _: "${inputs.self}/keys/${file}") (
          filterAttrs (_: t: t == "regular") (builtins.readDir "${inputs.self}/keys")
        );
      in
      {
        mutableUsers = false;
        inherit (cfg) defaultUserShell;
        users.${config.camms.user.name} = {
          isNormalUser = true;
          uid = 1000;
          extraGroups = optional (cfg.admin) "wheel" ++ cfg.extraGroups;
          inherit (cfg) hashedPasswordFile;
          openssh.authorizedKeys.keyFiles = keys;
        };
        users.root = {
          hashedPassword = "$6$Wn08sMD6v9xuAkRA$KOEYdp9ZeyJ/FSxNZ9ViH6/qvZwbRQ5GZuEdMVdfjAIdprWlXN8XGaI/nJCc0ByHtiwhKcwem9BHWRGGWG6RB1";
          openssh.authorizedKeys.keyFiles = keys;
        };
      };
    camms.user.hashedPasswordFile = mkIf sops (mkDefault config.sops.secrets.hashed_password.path);
    sops.secrets.hashed_password.neededForUsers = mkIf sops true;
  };
}
