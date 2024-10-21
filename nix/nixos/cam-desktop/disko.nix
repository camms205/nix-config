{
  disko.devices.disk.main = {
    type = "disk";
    device = "/dev/nvme0n1";
    content = {
      type = "gpt";
      partitions = {
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
        root = {
          size = "100%";
          content = {
            type = "btrfs";
            subvolumes = {
              "/@nixos" = {
                mountpoint = "/";
                mountOptions = [ "compress-force=zstd" ];
              };
              "/@home" = {
                mountpoint = "/home";
                mountOptions = [ "compress-force=zstd" ];
              };
              "/@nix" = {
                mountpoint = "/nix";
                mountOptions = [
                  "compress-force=zstd"
                  "noatime"
                ];
              };
            };
            mountpoint = "/media/btrfs";
          };
        };
      };
    };
  };
}
