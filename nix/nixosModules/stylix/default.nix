{
  pkgs,
  inputs,
  config,
  ...
}:
let
  theme = "catppuccin-mocha";
in
{
  imports = [ inputs.stylix.nixosModules.stylix ];

  config.stylix = {
    enable = true;
    # image =
    #   if config.networking.hostName or "" == "cam-laptop" then
    #     ./wallpapers/death_star.jpg
    #   else
    #     ./wallpapers/black-sand-dunes.jpg;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/${theme}.yaml";
    cursor = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
      size = 24;
    };
    targets.gtk.enable = true;
  };
}
