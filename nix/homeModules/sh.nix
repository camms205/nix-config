{
  lib,
  pkgs,
  inputs,
  config,
  ...
}:
let
  cfg = config.camms.sh;
in
with lib;
{
  imports = [ inputs.nix-index-database.hmModules.nix-index ];

  options.camms.sh.enable = mkEnableOption "sh";

  config = mkIf cfg.enable {
    camms.lf.enable = true;

    home.packages = with pkgs; [
      compsize
      dust
      entr
      eza
      fd
      nix-output-monitor
      nix-tree
      ripdrag
      texliveSmall
      unzip
    ];

    programs = {
      bat = {
        enable = true;
        extraPackages = with pkgs.bat-extras; [
          batdiff
          batman
        ];
      };
      btop = {
        enable = true;
        settings.vim_keys = true;
      };
      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
      fish = {
        enable = true;
        functions = {
          gi = ''${lib.getExe pkgs.curl} -sL https://www.toptal.com/developers/gitignore/api/$argv'';
          ts-exit = ''
            tailscale status --peers --json | nix run nixpkgs#jq -- '.ExitNodeStatus.ID as $node_id | .Peer[] | select(.ID==$node_id) | .HostName'
          '';
          cachix = ''env -S (cat /run/secrets/cachix) cachix $argv'';
        };
        shellAliases = {
          diff = "batdiff";
          ls = "eza";
          man = "batman";
          za = "zellij a -c";
        };
      };
      fzf.enable = true;
      git = {
        enable = true;
        delta.enable = true;
        userName = "camms205";
        userEmail = "camms205@proton.me";
        extraConfig = {
          init.defaultBranch = "main";
        };
      };
      lazygit.enable = true;
      man.generateCaches = true;
      nix-index.enable = true;
      nix-index-database.comma.enable = true;
      pandoc.enable = true;
      ripgrep.enable = true;
      starship.enable = true;
      yazi = {
        enable = true;
        enableFishIntegration = true;
      };
      zellij = {
        enable = true;
        enableFishIntegration = false;
        settings = {
          pane_frames = false;
        };
      };
      zoxide.enable = true;
    };
  };
}
