{ pkgs, inputs, ... }:
let
  theme = "catppuccin-mocha";
in
{
  flake-file.inputs.stylix.url = "github:danth/stylix";

  camms.stylix = {
    nixos = {
      imports = [ inputs.stylix.nixosModules.stylix ];

      stylix = {
        enable = true;
        base16Scheme = "${pkgs.base16-schemes}/share/themes/${theme}.yaml";
        cursor = {
          package = pkgs.adwaita-icon-theme;
          name = "Adwaita";
          size = 24;
        };
        targets.gtk.enable = true;
      };
    };

    homeManager = {
      gtk = {
        enable = true;
        iconTheme = {
          package = pkgs.adwaita-icon-theme;
          name = "Adwaita";
        };
      };
      qt.enable = true;
    };
  };
}
