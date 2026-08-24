{ den, ... }: {
  den.aspects.cameron = {
    includes = [
      den.batteries.primary-user
      (den.batteries.user-shell "fish")
    ];
  };
}
