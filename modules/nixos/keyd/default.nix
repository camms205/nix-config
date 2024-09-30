{
  lib,
  pkgs,
  inputs,
  namespace,
  config,
  ...
}:
let
  cfg = config.${namespace}.keyd;
in
with lib;
with lib.${namespace};
{
  options.${namespace}.keyd.enable = mkEnableOption "keyd";

  config.services.keyd = mkIf cfg.enable {
    enable = true;
    keyboards = {
      default = {
        ids = [ "*" ];
        settings = {
          main = {
            capslock = "layer(capslock)";
          };
          "capslock:C" = {
            "[" = "esc";
          };
        };
      };
    };
  };
}