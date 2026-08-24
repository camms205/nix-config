{ ... }:
{
  camms.keyd.nixos.services.keyd = {
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
