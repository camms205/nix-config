{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.camms.lf;
in
with lib;
{
  options.camms.lf.enable = mkEnableOption "lf";

  config.programs = mkIf cfg.enable {
    fish = {
      functions.lfcd = ''cd "$(command lf -print-last-dir $argv)"; commandline -f repaint'';
      interactiveShellInit = ''
        bind \eo lfcd
      '';
    };
    lf =
      let
        fzf = "${lib.getExe pkgs.fzf}";
        fd = "${lib.getExe pkgs.fd}";
        ctpv = "${lib.getExe' pkgs.ctpv "ctpv"}";
      in
      {
        enable = true;
        previewer.source = "${ctpv}/ctpv";
        settings = {
          cleaner = "${ctpv}/ctpvclear";
          findlen = 0;
          shell = "fish";
        };
        commands = {
          fzf = ''$lf -remote "send $id $(${fd} | ${fzf} | begin; read -l file; if test -d $file; echo "cd '$file'"; else; echo "select '$file'"; end; end)"'';
          fzf_all = ''$lf -remote "send $id $(${fd} -u | ${fzf} | begin; read -l file; if test -d $file; echo "cd '$file'"; else; echo "select '$file'"; end; end)"'';
        };
        keybindings = {
          f = "fzf";
          F = "fzf_all";
          c = "";
          u = ":clear; unselect";
          cd = ''push :cd<space>'';
        };
        extraConfig = ''
          &${ctpv}/ctpv -s $id
          &${ctpv}/ctpvquit $id
        '';
      };
  };
}
