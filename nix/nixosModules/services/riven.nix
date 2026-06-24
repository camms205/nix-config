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
    path = mkOption {
      type = types.str;
      default = "/media/riven";
      description = "The location of the mounts and media files";
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
    fileSystems."${cfg.path}" = {
      device = "${cfg.path}";
      fsType = "none";
      options = [
        "bind"
        "rshared"
      ];
    };

    # Generated from compose2nix based on https://riven.tv/generator
    # Runtime
    virtualisation.podman = {
      enable = true;
      autoPrune.enable = true;
      dockerCompat = true;
    };

    # Enable container name DNS for all Podman networks.
    networking.firewall.interfaces =
      let
        matchAll = if !config.networking.nftables.enable then "podman+" else "podman*";
      in
      {
        "${matchAll}".allowedUDPPorts = [ 53 ];
      };

    virtualisation.oci-containers.backend = "podman";

    # Containers
    virtualisation.oci-containers.containers."riven" = {
      image = "ghcr.io/rivenmedia/riven-ts:main";
      environmentFiles = mkIf (cfg.envFile != null) [ cfg.envFile ];
      inherit (cfg) environment;
      volumes = [
        "/tmp/riven/logs:/app/logs:rw"
        "${cfg.path}:/mount:rw,z,rshared"
      ];
      dependsOn = [
        "riven-postgres"
        "riven-redis"
      ];
      log-driver = "journald";
      extraOptions = [
        "--cap-add=SYS_ADMIN"
        "--device=/dev/fuse:/dev/fuse:rwm"
        "--network-alias=riven"
        "--network=riven_default"
        "--security-opt=apparmor:unconfined"
      ];
    };
    systemd.services."podman-riven" = {
      serviceConfig = {
        Restart = lib.mkOverride 90 "always";
      };
      after = [
        "podman-network-riven_default.service"
      ];
      requires = [
        "podman-network-riven_default.service"
      ];
      partOf = [
        "podman-compose-riven-root.target"
      ];
      wantedBy = [
        "podman-compose-riven-root.target"
      ];
    };
    virtualisation.oci-containers.containers."riven-postgres" = {
      image = "postgres:17-alpine";
      environment = {
        "POSTGRES_DB" = "riven";
        "POSTGRES_PASSWORD" = "713c6a705cdb7c1c7d84be27";
        "POSTGRES_USER" = "riven";
      };
      volumes = [
        "riven_postgres_data:/var/lib/postgresql/data:rw"
      ];
      log-driver = "journald";
      extraOptions = [
        "--health-cmd=pg_isready -U riven"
        "--health-interval=5s"
        "--health-retries=5"
        "--health-timeout=5s"
        "--network-alias=postgres"
        "--network=riven_default"
      ];
    };
    systemd.services."podman-riven-postgres" = {
      serviceConfig = {
        Restart = lib.mkOverride 90 "always";
      };
      after = [
        "podman-network-riven_default.service"
        "podman-volume-riven_postgres_data.service"
      ];
      requires = [
        "podman-network-riven_default.service"
        "podman-volume-riven_postgres_data.service"
      ];
      partOf = [
        "podman-compose-riven-root.target"
      ];
      wantedBy = [
        "podman-compose-riven-root.target"
      ];
    };
    virtualisation.oci-containers.containers."riven-redis" = {
      image = "redis:8-alpine";
      volumes = [
        "riven_redis_data:/data:rw"
      ];
      cmd = [
        "redis-server"
        "--maxmemory-policy"
        "noeviction"
        "--appendonly"
        "yes"
      ];
      log-driver = "journald";
      extraOptions = [
        "--health-cmd=redis-cli ping | grep PONG"
        "--health-interval=5s"
        "--health-retries=5"
        "--health-timeout=5s"
        "--network-alias=redis"
        "--network=riven_default"
      ];
    };
    systemd.services."podman-riven-redis" = {
      serviceConfig = {
        Restart = lib.mkOverride 90 "always";
      };
      after = [
        "podman-network-riven_default.service"
        "podman-volume-riven_redis_data.service"
      ];
      requires = [
        "podman-network-riven_default.service"
        "podman-volume-riven_redis_data.service"
      ];
      partOf = [
        "podman-compose-riven-root.target"
      ];
      wantedBy = [
        "podman-compose-riven-root.target"
      ];
    };

    # Networks
    systemd.services."podman-network-riven_default" = {
      path = [ pkgs.podman ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStop = "podman network rm -f riven_default";
      };
      script = ''
        podman network inspect riven_default || podman network create riven_default
      '';
      partOf = [ "podman-compose-riven-root.target" ];
      wantedBy = [ "podman-compose-riven-root.target" ];
    };

    # Volumes
    systemd.services."podman-volume-riven_postgres_data" = {
      path = [ pkgs.podman ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script = ''
        podman volume inspect riven_postgres_data || podman volume create riven_postgres_data
      '';
      partOf = [ "podman-compose-riven-root.target" ];
      wantedBy = [ "podman-compose-riven-root.target" ];
    };
    systemd.services."podman-volume-riven_redis_data" = {
      path = [ pkgs.podman ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script = ''
        podman volume inspect riven_redis_data || podman volume create riven_redis_data
      '';
      partOf = [ "podman-compose-riven-root.target" ];
      wantedBy = [ "podman-compose-riven-root.target" ];
    };

    # Root service
    # When started, this will automatically create all resources and start
    # the containers. When stopped, this will teardown all resources.
    systemd.targets."podman-compose-riven-root" = {
      unitConfig = {
        Description = "Root target generated by compose2nix.";
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}
