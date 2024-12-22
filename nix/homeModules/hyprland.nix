{
  lib,
  pkgs,
  inputs,
  config,
  osConfig,
  ...
}:
let
  cfg = config.camms.hyprland;
in
with lib;
{
  options.camms.hyprland.enable = mkEnableOption "hyprland";

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = false;
      settings = {
        "$mod" = "SUPER";
        monitor = [
          "eDP-1,highrr,auto,1.5667"
          "DP-3,highrr,auto,2"
          ",1920x1080@60,auto,1"
        ];
        xwayland.force_zero_scaling = true;
        env = [
          "GDK_SCALE,1.5"
          "XCURSOR_SIZE,24"
        ];
        input = {
          numlock_by_default = true;
          follow_mouse = 1;
          touchpad.natural_scroll = "yes";
          touchdevice.output = "DP-1";
        };
        general = {
          gaps_in = 0;
          gaps_out = 0;
          border_size = 2;
        };
        animations = {
          enabled = true;
          animation = [
            "windows,1,4,default,slide"
            "border,1,10,default"
            "fade,1,10,default"
            "workspaces,1,3,default,fade"
          ];
        };
        gestures.workspace_swipe = "no";
        misc = {
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
        };
        windowrule = [
          "float,title:Picture in picture"
          "pin,title:Picture in picture"
        ];
        bindm = [
          "$mod,mouse:272,movewindow"
          "$mod,mouse:273,resizewindow"
        ];
        bind =
          [
            "CTRL ALT,DELETE,exec,systemctl suspend"
            "$mod,Q,exec,uwsm app -- kitty"
            "$mod,RETURN,exec,uwsm app -- alacritty"
            "$mod,C,killactive,"
            "$mod,M,exit,"
            "$mod,E,exec,uwsm app -- dolphin"
            "$mod,V,togglefloating,"
            "$mod,F,fullscreen"
            "$mod,R,exec,fuzzel --launch-prefix='uwsm app --'"
            "$mod SHIFT,R,exec,wofi -d -o DP-3 | xargs hyprctl dispatch exec uwsm app --"
            "$mod,P,pseudo"
            "$mod,p,togglefloating"
            "$mod,p,pin"

            "$mod,left,movefocus,l"
            "$mod,right,movefocus,r"
            "$mod,up,movefocus,u"
            "$mod,down,movefocus,d"
            "$mod,h,movefocus,l"
            "$mod,l,movefocus,r"
            "$mod,k,movefocus,u"
            "$mod,j,movefocus,d"

            "$mod SHIFT,h,movewindow,l"
            "$mod SHIFT,l,movewindow,r"
            "$mod SHIFT,k,movewindow,u"
            "$mod SHIFT,j,movewindow,d"

            "$mod,mouse_down,workspace,e+1"
            "$mod,mouse_up,workspace,e-1"

            ",XF86AudioRaiseVolume,exec,pamixer -i 5"
            ",XF86AudioLowerVolume,exec,pamixer -d 5"
            ",XF86AudioMute,exec,pamixer -t"
            ",XF86AudioStop,exec,playerctl stop"
            ",XF86AudioPrev,exec,playerctl previous"
            ",XF86AudioPlay,exec,playerctl play-pause"
            "$mod_SHIFT,F10,exec,playerctl play-pause"
            ",XF86AudioNext,exec,playerctl next"
            "SHIFT,XF86AudioPrev,exec,playerctld shift"
            "SHIFT,XF86AudioPlay,exec,playerctl -a play-pause"
            "SHIFT,XF86AudioNext,exec,playerctld unshift"
            ",XF86MonBrightnessUp,exec,brightnessctl s +10%"
            ",XF86MonBrightnessDown,exec,brightnessctl s 10%-"

            ",XF86AudioMedia,exec,sleep 1 && hyprctl dispatch dpms off"
            "SHIFT,XF86AudioMedia,exec,sleep 1 && hyprctl dispatch dpms on"
            "$mod_SHIFT,F11,exec,sleep 1 && hyprctl dispatch dpms off"
            "$mod,F11,exec,sleep 1 && hyprctl dispatch dpms on"
            ",Print,exec,grimshot copy area"
          ]
          ++ (
            # workspaces
            builtins.concatLists (
              builtins.genList (
                i:
                let
                  ws = i + 1;
                in
                [
                  "$mod,${toString ws},workspace,${toString ws}"
                  "$mod SHIFT,${toString ws},movetoworkspace,${toString ws}"
                ]
              ) 9
              ++ [
                [
                  "$mod,0,workspace,10"
                  "$mod SHIFT,0,movetoworkspace,10"
                ]
              ]
            )
          );
        exec-once = [
          "systemctl --user start hyprpolkitagent"
          "systemctl --user start hypridle"
          "systemctl --user start hyprpaper"
          "uwsm app -- eww open bar"
          "uwsm app -- udiskie -ANt"
          "systemctl --user start blueman-applet"
          "[workspace 1 silent] uwsm app -- kitty"
          "[workspace 2 silent] uwsm app -- brave"
          #"[workspace 3 silent] uwsm app -- obsidian"
          "[workspace 10 silent;fullscreen] uwsm app -- kitty btop"
        ];
      };
      extraConfig = ''
        bind=$mod,Delete,submap,pass_keys
        submap=pass_keys
        bind=$mod,Delete,submap,reset
        submap=reset

        bind=ALT,r,submap,resize
        submap=resize
        binde=,l,resizeactive,10 0
        binde=,h,resizeactive,-10 0
        binde=,k,resizeactive,0 -10
        binde=,j,resizeactive,0 10

        binde=SHIFT,l,resizeactive,-10 0
        binde=SHIFT,h,resizeactive,10 0
        binde=SHIFT,k,resizeactive,0 10
        binde=SHIFT,j,resizeactive,0 -10

        binde=SHIFT,l,moveactive,10 0
        binde=SHIFT,h,moveactive,-10 0
        binde=SHIFT,k,moveactive,0 -10
        binde=SHIFT,j,moveactive,0 10

        bind=ALT,r,submap,reset
        submap=reset
      '';
    };

    home.packages = with pkgs; [
      gammastep
      hyprpolkitagent
      networkmanagerapplet
      pamixer
      pavucontrol
      playerctl
      sway-contrib.grimshot
      tigervnc
      waypipe
      wl-clipboard
      xdg-desktop-portal-hyprland
      hyprpaper
    ];

    services = {
      playerctld.enable = true;
      hypridle = {
        enable = true;
        settings = {
          general = {
            lock_cmd = "pidof hyprlock || hyprlock";
            before_sleep_cmd = "loginctl lock-session";
            after_sleep_cmd = "hyprctl dispatch dmps on";
          };
          listener = [
            {
              timeout = 300;
              on-timeout = "loginctl lock-session";
            }
            {
              timeout = 330;
              on-timeout = "hyprctl dispatch dpms off";
              on-resume = "hyprctl dispatch dpms on";
            }
            {
              timeout = 1800;
              on-timeout = "systemctl suspend";
            }
          ];
        };
      };
      hyprpaper.enable = true;
    };

    programs = {
      eww = mkIf (osConfig.camms.variables.ewwDir or null != null) {
        enable = true;
        package = pkgs.eww;
        configDir = osConfig.camms.variables.ewwDir;
      };
      fuzzel = {
        enable = true;
        settings = {
          main.show-actions = true;
        };
      };
      hyprlock = {
        enable = true;
        settings = {
          general = {
            disable_loading_bar = true;
            grace = 300;
            hide_cursor = true;
          };
          # background = [
          #   {
          #     path = "screenshot";
          #     blur_passes = 3;
          #     blur_size = 8;
          #   }
          # ];
          # input-field = [
          #   {
          #     size = "200, 50";
          #     position = "0, -80";
          #     monitor = "";
          #     dots_center = true;
          #     fade_on_empty = false;
          #     outline_thickness = 5;
          #     placeholder_text = ''<span foreground="##cad3f5">Password...</span>'';
          #     shadow_passes = 2;
          #   }
          # ];
        };
      };
    };
  };
}
