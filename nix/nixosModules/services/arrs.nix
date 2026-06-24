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
      envFile = config.sops.secrets."media/riven-ts.env".path;
      environment = {
        "PUID" = "${uid}";
        "PGID" = "${gid}";
        # "RIVEN_FORCE_ENV" = "true";
        # "RIVEN_SYMLINK_RCLONE_PATH" = "${path}/remote/realdebrid/torrents";
        # "RIVEN_SYMLINK_LIBRARY_PATH" = "${path}/jellyfin";
        # "RIVEN_DATABASE_HOST" = "postgresql+psycopg2://postgres:postgres@localhost:5433/riven";
        # "RIVEN_UPDATERS_JELLYFIN_URL" = "http://localhost:8096";
        # "RIVEN_CONTENT_OVERSEERR_URL" = "http://localhost:5055";
      };
    };

    users.users.${user} = {
      isSystemUser = true;
      uid = 10000;
      inherit group;
    };
    users.groups.${group} = {
      gid = 10000;
      members = [ config.camms.user.name ];
    };

    sops.secrets =
      let
        file = {
          owner = config.users.users.${user}.name;
          group = config.users.users.${user}.group;
          sopsFile = "${inputs.self}/secrets/arrs.yaml";
        };
      in
      {
        "media/riven-ts.env" = file;
        "media/riven.env" = file;
        "media/zurg-config.yml" = file;
      };

    services = {
      jellyfin = {
        enable = true;
        openFirewall = true;
        inherit user group;
      };
      jellyseerr.enable = true;
    };

    systemd = {
      # create all paths for mounts
      tmpfiles.rules = [
        "d ${path} - ${user} ${group} -"
        "d /tmp/riven/logs - ${user} ${group} -"
        # "d ${path}/jellyfin - ${user} ${group} -"
        # "d ${path}/jellyfin/movies - ${user} ${group} -"
        # "d ${path}/jellyfin/shows - ${user} ${group} -"
        # "d ${path}/remote - ${user} ${group} -"
        # "d ${path}/remote/realdebrid - ${user} ${group} -"
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
