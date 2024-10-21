{ writeText, nixosConfigurations, ... }:
let
  spec = {
    agents = builtins.mapAttrs (_: cfg: cfg.config.system.build.toplevel) nixosConfigurations;
  };
in
(writeText "deploy.json" (builtins.toJSON spec))
