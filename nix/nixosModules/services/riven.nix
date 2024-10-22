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
    mediaDir = mkOption {
      type = types.str;
      default = "/media/arrs";
    };
    dataDir = mkOption {
      type = types.str;
      default = "/var/lib/riven";
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
  };

  config = lib.mkIf cfg.enable {
    virtualisation.podman.autoPrune.enable = mkDefault true;
    virtualisation.oci-containers.containers = {
      "riven" = {
        image = "spoked/riven:latest";
        inherit (cfg) environment;
        environmentFiles = mkIf (cfg.envFile != null) [ cfg.envFile ];
        volumes = [
          "${cfg.dataDir}/data:/riven/data:rw"
          "${cfg.mediaDir}:${cfg.mediaDir}:rw"
        ];
        dependsOn = [ "riven-db" ];
        log-driver = "journald";
        extraOptions = [
          "--health-cmd=curl -s http://localhost:8080 >/dev/null || exit 1"
          "--health-interval=30s"
          "--health-retries=10"
          "--health-timeout=10s"
          "--network=host"
        ];
      };
      "riven-db" = {
        image = "postgres:16.3-alpine3.20";
        environment = {
          "PGDATA" = "/var/lib/postgresql/data/pgdata";
          "POSTGRES_DB" = "riven";
          "POSTGRES_PASSWORD" = "postgres";
          "POSTGRES_USER" = "postgres";
        };
        volumes = [
          "${cfg.dataDir}/riven-db:/var/lib/postgresql/data/pgdata:rw"
        ];
        log-driver = "journald";
        extraOptions = [
          "--health-cmd=pg_isready -U postgres"
          "--health-interval=10s"
          "--health-retries=5"
          "--health-timeout=5s"
          "--network=host"
        ];
      };
      "riven-frontend" = {
        image = "spoked/riven-frontend:latest";
        environment = {
          "BACKEND_URL" = "http://localhost:8080";
          "DATABASE_URL" = "postgres://postgres:postgres@localhost/riven";
          "DIALECT" = "postgres";
          "ORIGIN" = "http://localhost:3000";
        };
        dependsOn = [ "riven" ];
        log-driver = "journald";
        extraOptions = [ "--network=host" ];
      };
    };
  };
}
