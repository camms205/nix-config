{ den, lib, ... }: {
  den.default = {
    nixos.system.stateVersion = lib.mkDefault "24.05";
    homeManager.home.stateVersion = lib.mkDefault "24.05";

    includes = [
      den.batteries.define-user
      den.batteries.hostname
    ];

    config._module.args.__findFile = den.lib.__findFile;
  };
}
