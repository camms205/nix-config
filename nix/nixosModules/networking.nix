{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.camms.networking;
in
with lib;
{
  options.camms.networking = {
    manager = mkOption {
      type =
        with types;
        enum [
          "systemd"
          "NetworkManager"
        ];
      default = "NetworkManager";
    };
  };

  config = mkMerge [
    (mkIf (cfg.manager == "NetworkManager") {
      networking.networkmanager = {
        enable = true;
        plugins = [ pkgs.networkmanager-openvpn ];
      };
      systemd.network.wait-online.enable = false;
      camms.user.extraGroups = [
        "networkmanager"
      ];
    })
    {
      environment.systemPackages = with pkgs; [
        iproute2
        git
        socat
        sshfs
        wget
      ];
    }
  ];
}
