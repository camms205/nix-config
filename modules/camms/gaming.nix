{ den, ... }: {
  camms.gaming = {
    includes = [
      (den.batteries.unfree [
        "steam"
        "steam-unwrapped"
      ])
    ];

    nixos = { pkgs, ... }: {
      programs = {
        steam = {
          enable = true;
          extraCompatPackages = with pkgs; [ proton-ge-bin ];
          protontricks.enable = true;
        };
        gamescope = {
          enable = true;
          enableWsi = true;
          capSysNice = false;
        };
      };
    };
    homeManager = { pkgs, ... }: {
      home.packages = with pkgs; [
        mangohud
        prismlauncher
      ];
    };
  };
}
