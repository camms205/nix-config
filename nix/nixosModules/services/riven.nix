{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.camms.services.riven;
in
with lib;
{
  options.camms.services.riven = {
    enable = mkEnableOption "riven service";
    package = mkPackageOption pkgs "riven" { };
    dataDir = mkOption {
      type = types.str;
      default = "/var/lib/riven/data";
      description = "The directory where riven stores its data files";
    };
    envFile = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "The path to the env file to use";
    };

    user = mkOption {
      type = types.str;
      default = "riven";
      description = "User account under which riven runs.";
    };

    group = mkOption {
      type = types.str;
      default = "riven";
      description = "Group under which riven runs.";
    };

    environment = mkOption {
      type = types.anything;
      default = { };
    };

    frontend = {
      enable = mkEnableOption "riven frontend service" // {
        default = true;
      };
      package = mkPackageOption pkgs "riven-frontend" { };
      environment = mkOption {
        type = types.anything;
        default = { };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.tmpfiles.settings."10-riven".${cfg.dataDir}.d = {
      inherit (cfg) user group;
      mode = "0700";
    };

    systemd.services = {
      riven = {
        description = "riven";
        after = [ "network.target" ];
        wants = optional cfg.frontend.enable "riven-frontend.service";
        wantedBy = [ "multi-user.target" ];
        inherit (cfg) environment;

        serviceConfig = {
          Type = "simple";
          User = cfg.user;
          Group = cfg.group;
          ExecStart = "${cfg.package}/bin/riven";
          EnvironmentFile = mkIf (cfg.envFile != null) cfg.envFile;
          BindPaths = [ "${cfg.dataDir}:${cfg.package}/share/riven/data" ];
          Restart = "on-failure";
        };
      };
      riven-frontend = mkIf cfg.frontend.enable {
        description = "riven frontend";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        inherit (cfg.frontend) environment;
        serviceConfig = {
          Type = "simple";
          User = cfg.user;
          Group = cfg.group;
          ExecStart = "${cfg.frontend.package}/bin/riven-frontend";
          Restart = "on-failure";
        };
      };
    };
  };
}
