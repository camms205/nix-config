{
  lib,
  pkgs,
  inputs,
  config,
  osConfig ? { },
  ...
}:
let
  cfg = config.camms.helix;
in
with lib;
{
  options.camms.helix.enable = mkEnableOption "helix";

  config.programs.helix = mkIf cfg.enable {
    enable = true;
    defaultEditor = true;
    settings = {
      theme = mkForce "catppuccin_mocha";
      editor = {
        line-number = "relative";
        bufferline = "always";
        soft-wrap.enable = true;
        lsp.display-inlay-hints = true;
        cursor-shape.insert = "bar";
      };
      keys.normal = {
        esc = [
          "collapse_selection"
          "keep_primary_selection"
        ];
        "C-[" = [
          "collapse_selection"
          "keep_primary_selection"
        ];
      };
      keys.insert = {
        "C-[" = "normal_mode";
        j.k = "normal_mode";
      };
    };
    languages = {
      language = [
        {
          name = "python";
          auto-format = true;
        }
        {
          name = "cpp";
          auto-format = true;
          formatter.command = "clang-format";
        }
        {
          name = "nix";
          auto-format = true;
          formatter.command = "${pkgs.nixfmt-rfc-style}/bin/nixfmt";
          language-servers = [
            "nil"
            "nixd"
          ];
        }
      ];
      language-server = {
        rust-analyzer.config.checkOnSave.command = "clippy";
        nil.command = "${pkgs.nil}/bin/nil";
        nixd = {
          command = "${pkgs.nixd}/bin/nixd";
          config.nixd.options =
            let
              flake = osConfig.camms.variables.flakeDir or "${config.user.home.directory}/.config/nix";
            in
            {
              nixos.expr = ''(builtins.getFlake "${flake}").nixosConfigurations.cam-desktop.options'';
              home-manager.expr = ''(builtins.getFlake "${flake}").homeConfigurations.cameron@cam-desktop.options'';
              flake-parts.expr = ''(builtins.getFlake "${flake}").debug.options'';
              flake-parts2.expr = ''(builtins.getFlake "${flake}").currentSystem.options'';
            };
        };
      };
    };
  };
}
