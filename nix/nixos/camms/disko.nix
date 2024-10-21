{
  disko.devices = {
    disk.main = {
      type = "disk";
      device = "/dev/sda";
      content = {
        type = "gpt";
        partitions = {
          boot = {
            name = "boot";
            size = "1M";
            type = "EF02";
          };
          ESP = {
            priority = 1;
            type = "EF00";
            size = "1G";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
            };
          };
          zfs = {
            size = "100%";
            content = {
              type = "zfs";
              pool = "zroot";
            };
          };
        };
      };
    };
    zpool = {
      zroot = {
        type = "zpool";
        mode = "mirror";
        options.cachefile = "none";
        rootFsOptions = {
          compression = "zstd";
          "com.sun:auto-snapshot" = "false";
        };
        postCreateHook = "zfs list -t snapshot -H -o name | grep -E '^zroot@blank$' || zfs snapshot zroot@blank";
        datasets = {
          "root" = {
            type = "zfs_fs";
            mountpoint = "/";
          };
          "root/nix" = {
            type = "zfs_fs";
            mountpoint = "/nix";
          };
          "root/nix/persist" = {
            type = "zfs_fs";
            mountpoint = "/nix/persist";
          };
        };
      };
    };
  };
}
