{ lib, ... }: {
  den.hosts.x86_64-linux.cam-desktop.users.cameron = { };
  den.hosts.x86_64-linux.cam-laptop.users.cameron = { };
  den.hosts.x86_64-linux.camms.users.cameron = { };
  den.hosts.x86_64-linux.cms-server.users.cameron = { };

  den.schema.user.classes = lib.mkDefault [ "homeManager" ];
}
