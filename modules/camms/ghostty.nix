{ ... }:
{
  camms.ghostty.homeManager = { pkgs, ... }: {
    home.packages = [
      pkgs.ghostty
    ];

    xdg.configFile."ghostty/config".text = ''
      theme = Catppuccin Mocha
      font-family = FiraCode Nerd Font
      window-decoration = false
    '';
  };
}
