{
  camms.tailscale.nixos =
    { config, ... }:
    {
      services.tailscale = {
        enable = true;
        authKeyFile = config.sops.secrets.tailscale.path or "";
        useRoutingFeatures = "both";
        openFirewall = true;
      };
      sops.secrets."tailscale" = { };
    };
}
