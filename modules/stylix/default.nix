{
  inputs,
  ...
}:
let
  theme = "catppuccin-mocha";
in
{
  flake-file.inputs = {
    stylix.url = "github:danth/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";
  };

  camms.stylix.nixos = { pkgs, ... }: {
    imports = [ inputs.stylix.nixosModules.stylix ];

    config.stylix = {
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
}
