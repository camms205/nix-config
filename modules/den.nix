{
  inputs,
  den,
  lib,
  ...
}:
{
  imports = [
    inputs.den.flakeModules.dendritic
    (inputs.den.namespace "camms" false)
  ];

  flake.den = den;

  _module.args.__findFile = den.lib.__findFile;
}
