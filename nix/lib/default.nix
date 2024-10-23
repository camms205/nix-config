{ lib, ... }:
with lib;
rec {
  enabled = {
    enable = true;
  };
  getFiles =
    dir: exclude:
    mapAttrsToList (file: _: dir + ("/" + file)) (
      filterAttrs (name: type: type == "regular" && !elem name exclude) (builtins.readDir dir)
    );
  getFiles' = dir: getFiles dir [ ];
  defaultImports = dir: getFiles dir [ "default.nix" ];
}
