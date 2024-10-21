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
    users = {
      mutableUsers = false;
      inherit (cfg) defaultUserShell;
      users.${config.camms.variables.username} = {
        isNormalUser = true;
        uid = 1000;
        extraGroups = optional (cfg.admin) "wheel" ++ cfg.extraGroups;
        inherit (cfg) hashedPasswordFile;
      };
      users.root = {
        hashedPassword = "$6$Wn08sMD6v9xuAkRA$KOEYdp9ZeyJ/FSxNZ9ViH6/qvZwbRQ5GZuEdMVdfjAIdprWlXN8XGaI/nJCc0ByHtiwhKcwem9BHWRGGWG6RB1";
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJMumZUYRobSetz6wCJAIxryfbTUNf6fnGZU8P5RCcsW cameron@cam-desktop"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOTr+IuOrJF+tNJHjwHaNTMnV1PwbvuO+Z1XeXXIETeq cshearer@nixos-wsl"
        ];
      };
    };
    camms.user.hashedPasswordFile = mkIf sops (mkDefault config.sops.secrets.hashed_password.path);
    sops.secrets.hashed_password.neededForUsers = mkIf sops true;
  };
}
