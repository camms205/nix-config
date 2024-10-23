{ writeText, nixosConfigurations, ... }:
let
  spec = {
    agents = builtins.mapAttrs (_: cfg: cfg.config.system.build.toplevel) (
      builtins.removeAttrs nixosConfigurations [ "cms-server" ]
    );
  };
in
(writeText "deploy.json" (builtins.toJSON spec))
