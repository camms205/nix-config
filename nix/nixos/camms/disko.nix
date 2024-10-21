{
  disko.devices.disk.main = {
    type = "disk";
    device = "/dev/sda";
    content = {
      type = "gpt";
      partitions = {
        ESP = {
          priority = 1;
          type = "EF00";
          start = "1M";
          size = "1G";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = [ "umask=0077" ];
          };
        };
        root = {
          size = "100%";
          content = {
            type = "btrfs";
            subvolumes = {
              "/@" = {
                mountpoint = "/";
                mountOptions = [ "compress-force=zstd" ];
              };
              "/@nix" = {
                mountpoint = "/nix";
                mountOptions = [
                  "compress-force=zstd"
                  "noatime"
                ];
              };
              "/@persist" = {
                mountpoint = "/nix/persist";
                mountOptions = [ "compress-force=zstd" ];
              };
            };
          };
        };
      };
    };
  };
}
