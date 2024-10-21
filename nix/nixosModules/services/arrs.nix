{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
let
  cfg = config.camms.services.arrs;
  path = "${cfg.statePath}";
  user = "media";
  group = "media";
  uid = builtins.toString config.users.users.${user}.uid;
  gid = builtins.toString config.users.groups.${group}.gid;
in
with lib;
{
  options.camms.services.arrs = {
    enable = mkEnableOption "arrs stack";
    statePath = mkOption {
      type = types.str;
      default = "/media/arrs";
      description = "The location of the mounts and media files";
    };
  };

  config = mkIf cfg.enable {
    camms.services.riven = {
      enable = true;
      inherit user group;
      envFile = config.sops.secrets."media/riven.env".path;
      environment = {
        "RIVEN_FORCE_ENV" = "true";
        "RIVEN_SYMLINK_RCLONE_PATH" = "${path}/remote/realdebrid/torrents";
        "RIVEN_SYMLINK_LIBRARY_PATH" = "${path}/jellyfin";
        "RIVEN_DATABASE_HOST" = "postgresql+psycopg2://postgres:postgres@localhost/riven";
        "RIVEN_UPDATERS_JELLYFIN_URL" = "http://localhost:8096";
        "RIVEN_CONTENT_OVERSEERR_URL" = "http://localhost:5055";
      };
      frontend.environment = {
        "BACKEND_URL" = "http://localhost:8080";
        "DATABASE_URL" = "postgres://postgres:postgres@localhost/riven";
        "DIALECT" = "postgres";
        "ORIGIN" = "http://localhost:3000";
      };
    };

    users.users.${user} = {
      isSystemUser = true;
      uid = 10000;
      inherit group;
    };
    users.groups.${group} = {
      gid = 10000;
      members = [ config.camms.variables.username ];
    };

    sops.secrets =
      let
        file = {
          owner = config.users.users.${user}.name;
          group = config.users.users.${user}.group;
          sopsFile = "${inputs.self}/secrets/arrs.yaml";
        };
      in
      mkIf config.camms.sops.enable {
        "media/riven.env" = file;
        "media/zurg-config.yml" = file;
      };

    virtualisation = {
      podman.autoPrune.enable = true;
      oci-containers.containers."riven-db" = {
        image = "postgres:16.3-alpine3.20";
        environment = {
          "PGDATA" = "/var/lib/postgresql/data/pgdata";
          "POSTGRES_DB" = "riven";
          "POSTGRES_PASSWORD" = "postgres";
          "POSTGRES_USER" = "postgres";
        };
        volumes = [
          "/var/lib/riven/riven-db:/var/lib/postgresql/data/pgdata:rw"
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
    };

    services = {
      jellyfin = {
        enable = true;
        inherit user group;
      };
      jellyseerr.enable = true;
    };

    systemd = {
      services =
        let
          afterRclone = {
            after = [ "rclone.service" ];
            requires = [ "rclone.service" ];
            partOf = [ "arrs-root.target" ];
            wantedBy = [ "arrs-root.target" ];
          };
        in
        {
          "riven" = afterRclone;
          "riven-frontend" = afterRclone;
          "rclone" = {
            description = "rclone mount for zurg";
            after = [ "zurg.service" ];
            requires = [ "zurg.service" ];
            partOf = [ "arrs-root.target" ];
            serviceConfig = {
              Type = "simple";
              ExecStart = ''
                ${getExe pkgs.rclone} mount zurg: ${path}/remote/realdebrid --config="/var/lib/zurg/rclone.conf" \
                  --cache-dir=/tmp/rclone --allow-non-empty --allow-other --umask=002 --dir-cache-time 10s \
                  --vfs-cache-mode full --vfs-read-chunk-size 8M --vfs-read-chunk-size-limit 2G --buffer-size 16M \
                  --vfs-cache-max-age 150h --vfs-cache-max-size 20G --vfs-fast-fingerprint --uid ${uid} --gid ${gid}'';
              Restart = "on-failure";
            };
          };
          "zurg" = {
            description = "zurg";
            after = [ "network.target" ];
            partOf = [ "arrs-root.target" ];
            serviceConfig = {
              Type = "simple";
              User = user;
              Group = group;
              ExecStart = "${pkgs.zurg}/bin/zurg -c ${config.sops.secrets."media/zurg-config.yml".path}";
              WorkingDirectory = "/var/lib/zurg";
              Restart = "on-failure";
            };
          };
          "podman-riven-db" = {
            serviceConfig = {
              Restart = lib.mkOverride 500 "no";
            };
            partOf = [ "arrs-root.target" ];
            wantedBy = [ "arrs-root.target" ];
          };
          jellyfin = afterRclone;
          jellyseerr = afterRclone;
        };

      targets."arrs-root" = {
        unitConfig.Description = "Root target for arrs stack.";
        wantedBy = [ "multi-user.target" ];
      };

      # create all paths for mounts
      tmpfiles.rules = [
        "d ${path} - ${user} ${group} -"
        "d ${path}/jellyfin - ${user} ${group} -"
        "d ${path}/jellyfin/movies - ${user} ${group} -"
        "d ${path}/jellyfin/shows - ${user} ${group} -"
        "d ${path}/remote - ${user} ${group} -"
        "d ${path}/remote/realdebrid - ${user} ${group} -"
      ];
    };

    environment.persistence.${config.camms.impermanence.path} = mkIf config.camms.impermanence.enable {
      directories = [
        "/var/cache/jellyfin"
        "/var/lib/jellyfin"
        "/var/lib/private/jellyseerr"
        "/var/lib/riven"
        "/var/lib/zurg"
      ];
    };
  };
}
