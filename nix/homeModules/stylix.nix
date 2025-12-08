{
  pkgs,
  ...
}:
{
  config = {
    gtk = {
      enable = true;
      iconTheme = {
        package = pkgs.adwaita-icon-theme;
        name = "Adwaita";
      };
    };
    qt.enable = true;
  };
}
