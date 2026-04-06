{ camms, inputs, ... }:
{
  den.hosts.x86_64-linux.cam-desktop.users.cameron = { };

  den.aspects.cam-desktop = {
    includes = [ ];
    nixos =
      { config, pkgs, ... }:
      {
        imports = with inputs; [
          nixos-facter-modules.nixosModules.facter
          disko.nixosModules.disko
        ];
        facter.reportPath = ./facter.json;

        boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
        nix.settings.extra-platforms = config.boot.binfmt.emulatedSystems;
      };
  };
}
