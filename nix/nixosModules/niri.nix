{
  lib,
  pkgs,
  inputs,
  inputs',
  config,
  ...
}:
let
  cfg = config.camms.niri;
in
with lib;
{
  imports = [
    inputs.niri.nixosModules.niri
  ];

  options.camms.niri.enable = mkEnableOption "niri";

  config = mkMerge [
    { programs.niri.package = mkDefault pkgs.emptyDirectory; }
    (mkIf cfg.enable {
      programs.niri.enable = true;
      programs.niri.package = inputs'.niri.packages.niri-stable;
    })
  ];
}
