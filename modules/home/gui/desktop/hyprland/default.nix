{
  config,
  lib,
  inputs,
  pkgs,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.gui.desktop.hyprland;
in
{
  options.${namespace}.gui.desktop.hyprland = {
    enable = lib.mkEnableOption "hyprland";
  };

  config = lib.mkIf cfg.enable {
    # nix.settings = {
    #   substituters = ["https://hyprland.cachix.org"];
    #   trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    # };

    wayland.windowManager.hyprland = {
      enable = true;
      plugins = [ ];
      xwayland = {
        enable = true;
      };

      package = null;
      portalPackage = null;

      settings = {
        "$terminal" = "foot";
        "$terminalexec" = "$terminal -e";
        "$browser" = "brave";
        "$calculator" = "qalculate-gtk";
        "$resourceman" = "btop";
        "$ide" = "zeditor";
        "$fileManager" = "thunar";
        "$menu" = "rofi -show drun -show-icons";
        "$mainMod" = "SUPER";
        "$passman" = "proton-pass";
        "$obsidian" = "obsidian";

        "$ws_1" = "name:term";
        "$ws_2" = "name:ide";
        "$ws_3" = "name:browser";
        "$ws_4" = "name:social";
        "$ws_5" = "5";
        "$ws_6" = "6";
        "$ws_7" = "7";
        "$ws_8" = "8";
        "$ws_9" = "9";
        "$ws_10" = "10";

        monitor = [
          ",preferred,auto,1"
        ];

        env = [
          "XCURSOR_SIZE,24"
          "HYPRCURSOR_SIZE,24"
          "ELECTRON_OZONE_PLATFORM_HINT,x11"
          "XDG_CURRENT_DESKTOP,Hyprland"
          "XDG_SESSION_DESKTOP,Hyprland"
          "XDG_SESSION_TYPE,wayland"
        ];

        general = {
          border_size = 1;
          no_border_on_floating = false;
          gaps_in = 2;
          gaps_out = 10;
          float_gaps = 0;
          gaps_workspaces = 0;

          "col.inactive_border" = lib.mkDefault "0xff444444";
          "col.active_border" = lib.mkDefault "0xffffffff";
          "col.nogroup_border" = lib.mkDefault "0xffffaaff";
          "col.nogroup_border_active" = lib.mkDefault "0xffff00ff";

          layout = "dwindle";
          no_focus_fallback = false;
          resize_on_border = false;
          extend_border_grab_area = 15;
          hover_icon_on_border = true;
          allow_tearing = false;
          resize_corner = 0;

          snap = {
            enabled = false;
            window_gap = 10;
            monitor_gap = 10;
            border_overlap = false;
            respect_gaps = false;
          };
        };

        decoration = {
          rounding = 6;
          rounding_power = 2.0;
          active_opacity = 1.0;
          inactive_opacity = 1.0;
          fullscreen_opacity = 1.0;
          dim_inactive = false;
          dim_strength = 0.5;
          dim_special = 0.2;
          dim_around = 0.4;
          screen_shader = "";
          border_part_of_window = true;

          blur = {
            enabled = true;
            size = 3;
            passes = 1;
            ignore_opacity = true;
            new_optimizations = true;
            xray = false;
            noise = 0.0117;
            contrast = 0.8916;
            brightness = 0.8172;
            vibrancy = 0.1696;
            vibrancy_darkness = 0.0;
            special = false;
            popups = false;
            popups_ignorealpha = 0.2;
            input_methods = false;
            input_methods_ignorealpha = 0.2;
          };

          shadow = {
            enabled = true;
            range = 4;
            render_power = 3;
            sharp = false;
            ignore_window = true;
            color = lib.mkDefault "1a1a1aee";
            # color_inactive = ""; # unset
            offset = "0 0";
            scale = 1.0;
          };
        };

        animations = {
          enabled = true;
          workspace_wraparound = false;

          bezier = [
            "easeOutQuint,0.23,1,0.32,1"
            "easeInOutCubic,0.65,0.05,0.36,1"
            "linear,0,0,1,1"
            "almostLinear,0.5,0.5,0.75,1.0"
            "quick,0.15,0,0.1,1"
          ];

          animation = [
            "global, 1, 10, default"
            "border, 1, 5.39, easeOutQuint"
            "windows, 1, 4.79, easeOutQuint"
            "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
            "windowsOut, 1, 1.49, linear, popin 87%"
            "fadeIn, 1, 1.73, almostLinear"
            "fadeOut, 1, 1.46, almostLinear"
            "fade, 1, 3.03, quick"
            "layers, 1, 3.81, easeOutQuint"
            "layersIn, 1, 4, easeOutQuint, fade"
            "layersOut, 1, 1.5, linear, fade"
            "fadeLayersIn, 1, 1.79, almostLinear"
            "fadeLayersOut, 1, 1.39, almostLinear"
            "workspaces, 1, 1.94, almostLinear, fade"
            "workspacesIn, 1, 1.21, almostLinear, fade"
            "workspacesOut, 1, 1.94, almostLinear, fade"
          ];
        };

        input = {
          kb_model = "";
          kb_layout = "us";
          kb_variant = "";
          kb_options = "";
          kb_rules = "";
          kb_file = "";
          numlock_by_default = false;
          resolve_binds_by_sym = false;
          repeat_rate = 25;
          repeat_delay = 600;
          sensitivity = 0.0;
          accel_profile = "";
          force_no_accel = false;
          left_handed = false;
          scroll_points = "";
          scroll_method = "";
          scroll_button = 0;
          scroll_button_lock = false;
          scroll_factor = 1.0;
          natural_scroll = false;
          follow_mouse = 1;
          follow_mouse_threshold = 0.0;
          focus_on_close = 0;
          mouse_refocus = true;
          float_switch_override_focus = 1;
          special_fallthrough = false;
          off_window_axis_events = 1;
          emulate_discrete_scroll = 1;

          touchpad = {
            disable_while_typing = true;
            natural_scroll = false;
            scroll_factor = 1.0;
            middle_button_emulation = false;
            tap_button_map = "";
            clickfinger_behavior = false;
            tap-to-click = true;
            drag_lock = 2;
            tap-and-drag = true;
            flip_x = false;
            flip_y = false;
            drag_3fg = 0;
          };

          touchdevice = {
            transform = -1;
            output = "[[Auto]]";
            enabled = true;
          };

          tablet = {
            transform = -1;
            output = "";
            region_position = "0 0";
            absolute_region_position = false;
            region_size = "0 0";
            relative_input = false;
            left_handed = false;
            active_area_size = "0 0";
            active_area_position = "0 0";
          };
        };

        gestures = {
          workspace_swipe = false;
          workspace_swipe_fingers = 3;
          workspace_swipe_min_fingers = false;
          workspace_swipe_distance = 300;
          workspace_swipe_touch = false;
          workspace_swipe_invert = true;
          workspace_swipe_touch_invert = false;
          workspace_swipe_min_speed_to_force = 30;
          workspace_swipe_cancel_ratio = 0.5;
          workspace_swipe_create_new = true;
          workspace_swipe_direction_lock = true;
          workspace_swipe_direction_lock_threshold = 10;
          workspace_swipe_forever = false;
          workspace_swipe_use_r = false;
        };

        group = {
          auto_group = true;
          insert_after_current = true;
          focus_removed_window = true;
          drag_into_group = 1;
          merge_groups_on_drag = true;
          merge_groups_on_groupbar = true;
          merge_floated_into_tiled_on_groupbar = false;
          group_on_movetoworkspace = false;

          "col.border_active" = lib.mkDefault "0x66ffff00";
          "col.border_inactive" = lib.mkDefault "0x66777700";
          "col.border_locked_active" = lib.mkDefault "0x66ff5500";
          "col.border_locked_inactive" = lib.mkDefault "0x66775500";

          groupbar = {
            enabled = true;
            font_family = "";
            font_size = 8;
            font_weight_active = "normal";
            font_weight_inactive = "normal";
            gradients = false;
            height = 14;
            indicator_gap = 0;
            indicator_height = 3;
            stacked = false;
            priority = 3;
            render_titles = true;
            text_offset = 0;
            scrolling = true;
            rounding = 1;
            gradient_rounding = 2;
            round_only_edges = true;
            gradient_round_only_edges = true;
            text_color = lib.mkDefault "0xffffffff";
            # text_color_inactive = null; # unset
            # text_color_locked_active = null; # unset
            # text_color_locked_inactive = null; # unset
            "col.active" = lib.mkDefault "0x66ffff00";
            "col.inactive" = lib.mkDefault "0x66777700";
            "col.locked_active" = lib.mkDefault "0x66ff5500";
            "col.locked_inactive" = lib.mkDefault "0x66775500";
            gaps_in = 2;
            gaps_out = 2;
            keep_upper_gap = true;
          };
        };

        misc = {
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
          "col.splash" = "0xffffffff";
          font_family = lib.mkDefault "Sans";
          splash_font_family = "";
          force_default_wallpaper = 0;
          vfr = true;
          vrr = 1;
          mouse_move_enables_dpms = false;
          key_press_enables_dpms = false;
          always_follow_on_dnd = true;
          layers_hog_keyboard_focus = true;
          animate_manual_resizes = false;
          animate_mouse_windowdragging = false;
          disable_autoreload = false;
          enable_swallow = false;
          swallow_regex = "";
          swallow_exception_regex = "";
          focus_on_activate = false;
          mouse_move_focuses_monitor = true;
          allow_session_lock_restore = false;
          # session_lock_xray = false; # does not exist. Bug in documentation?
          background_color = lib.mkDefault "0x111111";
          close_special_on_empty = true;
          new_window_takes_over_fullscreen = 0;
          exit_window_retains_fullscreen = false;
          initial_workspace_tracking = 1;
          middle_click_paste = true;
          render_unfocused_fps = 15;
          disable_xdg_env_checks = false;
          disable_hyprland_qtutils_check = false;
          lockdead_screen_delay = 1000;
          enable_anr_dialog = true;
          anr_missed_pings = 1;
        };

        binds = {
          pass_mouse_when_bound = false;
          scroll_event_delay = 300;
          workspace_back_and_forth = false;
          hide_special_on_workspace_change = false;
          allow_workspace_cycles = false;
          workspace_center_on = 0;
          focus_preferred_method = 0;
          ignore_group_lock = false;
          movefocus_cycles_fullscreen = false;
          movefocus_cycles_groupfirst = false;
          disable_keybind_grabbing = false;
          window_direction_monitor_fallback = true;
          allow_pin_fullscreen = false;
          drag_threshold = 0;
        };

        xwayland = {
          enabled = true;
          use_nearest_neighbor = true;
          force_zero_scaling = false;
          create_abstract_socket = false;
        };

        opengl = {
          nvidia_anti_flicker = false;
        };

        render = {
          direct_scanout = 0;
          expand_undersized_textures = true;
          xp_mode = false;
          ctm_animation = 2;
          cm_fs_passthrough = 2;
          cm_enabled = true;
          send_content_type = true;
          cm_auto_hdr = 1;
          new_render_scheduling = false;
        };

        cursor = {
          sync_gsettings_theme = true;
          no_hardware_cursors = 1;
          no_break_fs_vrr = 2;
          min_refresh_rate = 24;
          hotspot_padding = 1;
          inactive_timeout = 0;
          no_warps = false;
          persistent_warps = false;
          warp_on_change_workspace = 0;
          warp_on_toggle_special = 0;
          default_monitor = "[[EMPTY]]";
          zoom_factor = 1.0;
          zoom_rigid = false;
          enable_hyprcursor = true;
          hide_on_key_press = false;
          hide_on_touch = true;
          use_cpu_buffer = 2;
          warp_back_after_non_mouse_input = false;
        };

        ecosystem = {
          no_update_news = false;
          no_donation_nag = false;
          enforce_permissions = false;
        };

        experimental = {
          xx_color_management_v4 = false;
        };

        debug = {
          overlay = false;
          damage_blink = false;
          disable_logs = true;
          disable_time = true;
          damage_tracking = 2;
          enable_stdout_logs = false;
          manual_crash = 0;
          suppress_errors = false;
          # watchdog_timeout = 5;
          disable_scale_checks = false;
          error_limit = 5;
          error_position = 0;
          colored_stdout_logs = true;
          pass = false;
          full_cm_proto = false;
        };

        dwindle = {
          pseudotile = true;
          force_split = 0;
          preserve_split = true;
          smart_split = false;
          smart_resizing = true;
          permanent_direction_override = false;
          special_scale_factor = 1;
          split_width_multiplier = 1.0;
          use_active_for_splits = true;
          default_split_ratio = 1.0;
          split_bias = 0;
          precise_mouse_move = false;
          single_window_aspect_ratio = "0 0";
          single_window_aspect_ratio_tolerance = 0.1;
        };

        master = {
          new_status = "master";
        };

        device = {
          name = "epic-mouse-v1";
          sensitivity = -0.5;
        };

        bind = [
          "$mainMod, space, exec, $menu"
          "$mainMod, T, exec, $terminal"
          "$mainMod, Q, killactive,"
          "$mainMod, F, togglefloating,"
          "$mainMod, E, exec, $fileManager"
          "$mainMod, S, exec, shotman -c region -C"
          "$mainMod, D, exec, GDK_BACKEND=x11 dbeaver"

          "$mainMod, M, exit,"
          "$mainMod, P, pseudo,"
          "$mainMod, J, togglesplit,"
          "$mainMod, L, exec, ${pkgs.hyprlock}/bin/hyprlock"

          "$mainMod ALT, M, exec, reboot"

          "$mainMod, left, movefocus, l"
          "$mainMod, right, movefocus, r"
          "$mainMod, up, movefocus, u"
          "$mainMod, down, movefocus, d"

          "$mainMod, 1, workspace, $ws_1"
          "$mainMod, 2, workspace, $ws_2"
          "$mainMod, 3, workspace, $ws_3"
          "$mainMod, 4, workspace, $ws_4"
          "$mainMod, 5, workspace, 5"
          "$mainMod, 6, workspace, 6"
          "$mainMod, 7, workspace, 7"
          "$mainMod, 8, workspace, 8"
          "$mainMod, 9, workspace, 9"
          "$mainMod, 0, workspace, 10"

          "$mainMod SHIFT, 1, movetoworkspace, $ws_1"
          "$mainMod SHIFT, 2, movetoworkspace, $ws_2"
          "$mainMod SHIFT, 3, movetoworkspace, $ws_3"
          "$mainMod SHIFT, 4, movetoworkspace, $ws_4"
          "$mainMod SHIFT, 5, movetoworkspace, 5"
          "$mainMod SHIFT, 6, movetoworkspace, 6"
          "$mainMod SHIFT, 7, movetoworkspace, 7"
          "$mainMod SHIFT, 8, movetoworkspace, 8"
          "$mainMod SHIFT, 9, movetoworkspace, 9"
          "$mainMod SHIFT, 0, movetoworkspace, 10"

          "$mainMod SHIFT, Q, exec, pgrep $calculator && hyprctl dispatch togglespecialworkspace special:calculator || $calculator &"
          "$mainMod SHIFT, P, exec, hyprctl dispatch togglespecialworkspace special:passman && $passman &"
          "$mainMod SHIFT, R, exec, hyprctl clients -j | jq  '.[].title' | grep \"$resourceman\" && hyprctl dispatch togglespecialworkspace special:resourceman || $terminalexec $resourceman"
          "$mainMod SHIFT, O, exec, hyprctl clients -j | jq  '.[].class' | grep \"obsidian\" && hyprctl dispatch togglespecialworkspace special:obsidian || $obsidian"

          # "$mainMod, S, togglespecialworkspace, magic"
          # "$mainMod SHIFT, S, movetoworkspace, special:magic"

          "$mainMod, mouse_down, workspace, e+1"
          "$mainMod, mouse_up, workspace, e-1"
        ];

        bindm = [
          "$mainMod, mouse:272, movewindow"
          "$mainMod, mouse:273, resizewindow"
        ];

        bindel = [
          ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
          ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
          ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
          ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
        ];

        bindl = [
          ", XF86AudioNext, exec, playerctl next"
          ", XF86AudioPause, exec, playerctl play-pause"
          ", XF86AudioPlay, exec, playerctl play-pause"
          ", XF86AudioPrev, exec, playerctl previous"
        ];

        rule = [

        ];

        workspace = [
          "$ws_1, monitor:DP-1, default:true"
          "$ws_2, monitor:DP-2, default:true"
          "$ws_3, monitor:DP-2, default:true"
          "$ws_4, monitor:DP-2, default:true"

          "special:calculator s[true]"
          "special:passman s[true]"
          "special:resourceman s[true]"
          "special:obsidian s[true]"
        ];

        windowrulev2 = [
          "suppressevent maximize, class:.*"
          "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"

          ######## TAGS ########
          "tag:+browser class:^(brave-browser)$"
          "tag:+browser class:^(firefox)$"

          "tag:+ide class:^(code)$"

          "tag:+term class:^(kitty)$"
          "tag:+term class:^(foot)$"
          "tag:+term class:^(com.mitchellh.ghostty)$"

          "float, class:(clipse)"
          "size 622 652, class:(clipse)"
          "stayfocused, class:(clipse)"

          "float,class:($calculator)"
          "workspace special:special:calculator,class:($calculator)"
          "size 622 652, class:($calculator)"
          "stayfocused, class:($calculator)"

          "float,class:($passman)"
          "workspace special:special:passman,class:($passman)"
          "size 622 652, class:($passman)"
          "stayfocused, class:($passman)"

          "float,title:($resourceman)"
          "workspace special:special:resourceman,title:($resourceman)"
          "size 622 652, title:($resourceman)"
          "stayfocused, title:($resourceman)"

          "float,class:($obsidian)"
          "workspace special:special:obsidian,class:($obsidian)"
          "size 622 652, class:($obsidian)"

          "workspace name:ide tag:^ide$"
        ];

        exec-once = [
          "nm-applet --indicator"
          "clipse -listen"

          "[workspace $ws_1 silent] $terminal"
          "[workspace $ws_2 silent] $ide"
          "[workspace $ws_3 silent] $browser"
          "[workspace $ws_4 silent] slack"
        ];
      };

      systemd = {
        enable = true;
        variables = [ "--all" ];
      };
    };

    home = {
      packages = with pkgs; [
        rofi-wayland
        networkmanagerapplet
        brightnessctl
        playerctl
      ];

      # pointerCursor = {
      #   # gtk.enable = true;
      #   # x11.enable = true;
      #   package = pkgs.bibata-cursors;
      #   name = "Bibata_AdaptaBreath_Cursors";
      #   size = 16;
      # };
    };
  };
}
