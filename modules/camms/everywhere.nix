{ den, camms, ... }:
{
  den.aspects.cameron.includes = [ camms.everywhere ];
  camms.everywhere = {
    includes = [
      den.provides.primary-user
      camms.nix-index
    ];
  };
}
