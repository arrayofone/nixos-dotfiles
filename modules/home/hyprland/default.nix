# @gitian:module Home-manager Hyprland config — comprehensive window manager settings
# including dwindle/master layouts (golden-ratio splits), animations, keybindings,
# workspace rules, and special workspaces for calculator/password-manager/notes.
{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.hyprland;
in
{
  options.${namespace}.hyprland = {
    enable = lib.mkEnableOption "hyprland";
  };

  config = lib.mkIf cfg.enable {
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
          ",highres,auto,1"
        ];

        env = [
          # Cursor
          "XCURSOR_SIZE,24"
          "XCURSOR_THEME,Bibata-Modern-Ice"
          "HYPRCURSOR_SIZE,24"
          "HYPRCURSOR_THEME,Bibata-Modern-Ice"

          # Electron/Chromium Wayland
          "ELECTRON_OZONE_PLATFORM_HINT,auto"
          "NIXOS_OZONE_WL,1"

          # XDG Desktop
          "XDG_CURRENT_DESKTOP,Hyprland"
          "XDG_SESSION_DESKTOP,Hyprland"
          "XDG_SESSION_TYPE,wayland"

          # Qt theming
          "QT_QPA_PLATFORM,wayland;xcb"
          "QT_QPA_PLATFORMTHEME,kvantum"
          "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
          "QT_AUTO_SCREEN_SCALE_FACTOR,1"

          # GTK
          "GDK_BACKEND,wayland,x11,*"
          "GTK_THEME,Catppuccin-Macchiato-Standard-Mauve-Dark"
        ];

        general = {
          border_size = 3;
          gaps_in = 6;
          gaps_out = 16;
          float_gaps = 0;
          gaps_workspaces = 50;

          # Catppuccin Macchiato gradient border
          "col.inactive_border" = lib.mkDefault "rgba(363a4f88)";
          "col.active_border" = lib.mkDefault "rgba(c6a0f6ff) rgba(8bd5caff) rgba(8aadf4ff) 45deg";
          "col.nogroup_border" = lib.mkDefault "rgba(494d6488)";
          "col.nogroup_border_active" = lib.mkDefault "rgba(ed8796ff)";

          layout = "dwindle";
          no_focus_fallback = false;
          resize_on_border = true;
          extend_border_grab_area = 20;
          hover_icon_on_border = true;
          allow_tearing = false;
          resize_corner = 0;

          snap = {
            enabled = true;
            window_gap = 15;
            monitor_gap = 20;
            border_overlap = true;
            respect_gaps = true;
          };
        };

        decoration = {
          rounding = 14;
          rounding_power = 2.2;
          active_opacity = 1.0;
          inactive_opacity = 0.92;
          fullscreen_opacity = 1.0;
          dim_inactive = true;
          dim_strength = 0.12;
          dim_special = 0.3;
          dim_around = 0.5;
          screen_shader = "";
          border_part_of_window = true;

          blur = {
            enabled = true;
            size = 12;
            passes = 4;
            ignore_opacity = true;
            new_optimizations = true;
            xray = false;
            noise = 0.02;
            contrast = 1.05;
            brightness = 0.95;
            vibrancy = 0.3;
            vibrancy_darkness = 0.3;
            special = true;
            popups = true;
            popups_ignorealpha = 0.5;
            input_methods = true;
            input_methods_ignorealpha = 0.5;
          };

          shadow = {
            enabled = true;
            range = 20;
            render_power = 4;
            sharp = false;
            ignore_window = true;
            color = lib.mkDefault "rgba(1a1a2ecc)";
            color_inactive = lib.mkDefault "rgba(1a1a2e99)";
            offset = "0 12";
            scale = 0.95;
          };
        };

        animations = {
          enabled = true;
          workspace_wraparound = false;

          bezier = [
            # Smooth and snappy
            "smoothOut, 0.36, 0, 0.66, -0.56"
            "smoothIn, 0.25, 1, 0.5, 1"
            "overshot, 0.05, 0.9, 0.1, 1.1"

            # Fluent design inspired
            "fluent_decel, 0.1, 1, 0, 1"
            "easeOutCirc, 0, 0.55, 0.45, 1"
            "easeOutCubic, 0.33, 1, 0.68, 1"
            "easeInOutQuart, 0.76, 0, 0.24, 1"

            # Elastic and bouncy
            "elastic, 0.68, -0.6, 0.32, 1.6"
            "bounce, 0.175, 0.885, 0.32, 1.275"

            # Utility
            "linear, 0, 0, 1, 1"
            "quick, 0.15, 0, 0.1, 1"
          ];

          animation = [
            "global, 1, 6, default"

            # Border animations - rotating gradient
            "border, 1, 8, fluent_decel"
            "borderangle, 1, 100, linear, loop"

            # Window animations
            "windows, 1, 5, overshot, popin 80%"
            "windowsIn, 1, 5, bounce, popin 80%"
            "windowsOut, 1, 4, smoothOut, popin 80%"
            "windowsMove, 1, 5, overshot, slide"

            # Fade animations
            "fadeIn, 1, 4, smoothIn"
            "fadeOut, 1, 4, smoothOut"
            "fade, 1, 6, smoothIn"
            "fadeDim, 1, 6, smoothIn"
            "fadeShadow, 1, 6, smoothIn"

            # Layer animations (rofi, waybar, etc.)
            "layers, 1, 4, smoothIn, fade"
            "layersIn, 1, 4, bounce, slide"
            "layersOut, 1, 3, smoothOut, slide"

            # Workspace animations
            "workspaces, 1, 5, overshot, slide"
            "workspacesIn, 1, 5, bounce, slidefade 20%"
            "workspacesOut, 1, 5, smoothOut, slidefade 20%"
            "specialWorkspace, 1, 4, bounce, slidevert"
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
          # workspace_swipe = false;
          # workspace_swipe_fingers = 3;
          # workspace_swipe_min_fingers = false;
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

          # Catppuccin Macchiato group colors
          "col.border_active" = lib.mkDefault "rgba(c6a0f6ff)";
          "col.border_inactive" = lib.mkDefault "rgba(494d6488)";
          "col.border_locked_active" = lib.mkDefault "rgba(ed8796ff)";
          "col.border_locked_inactive" = lib.mkDefault "rgba(5b607888)";

          groupbar = {
            enabled = true;
            font_family = "Ubuntu Sans";
            font_size = 11;
            font_weight_active = "bold";
            font_weight_inactive = "normal";
            gradients = true;
            height = 22;
            indicator_gap = 2;
            indicator_height = 4;
            stacked = false;
            priority = 3;
            render_titles = true;
            text_offset = 0;
            scrolling = true;
            rounding = 10;
            gradient_rounding = 8;
            round_only_edges = true;
            gradient_round_only_edges = true;
            # Catppuccin Macchiato text colors
            text_color = lib.mkDefault "rgba(cad3f5ff)";
            text_color_inactive = lib.mkDefault "rgba(a5adcbcc)";
            text_color_locked_active = lib.mkDefault "rgba(ed8796ff)";
            text_color_locked_inactive = lib.mkDefault "rgba(ee99a0cc)";
            # Catppuccin Macchiato bar colors
            "col.active" = lib.mkDefault "rgba(c6a0f6cc)";
            "col.inactive" = lib.mkDefault "rgba(363a4fcc)";
            "col.locked_active" = lib.mkDefault "rgba(ed8796cc)";
            "col.locked_inactive" = lib.mkDefault "rgba(494d64cc)";
            gaps_in = 3;
            gaps_out = 3;
            keep_upper_gap = true;
          };
        };

        misc = {
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
          "col.splash" = "rgba(c6a0f6ff)";
          font_family = lib.mkDefault "Ubuntu";
          splash_font_family = "Ubuntu Sans";
          force_default_wallpaper = 0;
          vfr = true;
          vrr = 1;
          mouse_move_enables_dpms = false;
          key_press_enables_dpms = false;
          always_follow_on_dnd = true;
          layers_hog_keyboard_focus = true;
          animate_manual_resizes = true;
          animate_mouse_windowdragging = true;
          disable_autoreload = false;
          enable_swallow = false;
          swallow_regex = "";
          swallow_exception_regex = "";
          focus_on_activate = false;
          mouse_move_focuses_monitor = true;
          allow_session_lock_restore = false;
          # session_lock_xray = false; # does not exist. Bug in documentation?
          background_color = lib.mkDefault "0x24273a";
          close_special_on_empty = true;
          exit_window_retains_fullscreen = false;
          initial_workspace_tracking = 1;
          middle_click_paste = true;
          render_unfocused_fps = 15;
          disable_xdg_env_checks = false;
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
          sync_gsettings_theme = false;
          no_hardware_cursors = 2;
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
          # xx_color_management_v4 = false;
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
          force_split = 2;
          preserve_split = true;
          smart_split = true;
          smart_resizing = true;
          permanent_direction_override = false;
          special_scale_factor = 0.8;
          split_width_multiplier = 1.0;
          use_active_for_splits = true;
          default_split_ratio = 1.618; # Golden ratio for elegant proportions
          split_bias = 0;
          precise_mouse_move = true;
          single_window_aspect_ratio = "16 10";
          single_window_aspect_ratio_tolerance = 0.15;
        };

        master = {
          allow_small_split = true;
          new_status = "master";
          new_on_active = "after";
          new_on_top = false;
          orientation = "left";
          smart_resizing = true;
          drop_at_cursor = true;
          mfact = 0.618; # Golden ratio for master area
          special_scale_factor = 0.8;
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

          # Smart workspace layouts
          "$ws_1, layoutopt:orientation:left"
          "$ws_2, layoutopt:orientation:top"
          "$ws_3, layoutopt:orientation:right"
          "$ws_4, layoutopt:orientation:center"

          "special:calculator s[true]"
          "special:passman s[true]"
          "special:obsidian s[true]"
        ];

        # windowrule = [
        #   "suppressevent maximize, class:.*"
        #   "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"

        #   ######## SMART TILING RULES ########
        #   # Browsers - optimized for reading and productivity
        #   "size 70% 100%, class:^(brave-browser)$"
        #   "tile, class:^(brave-browser)$"
        #   "group set always, class:^(brave-browser)$"
        #   "size 70% 100%, class:^(firefox)$"
        #   "tile, class:^(firefox)$"
        #   "group set always, class:^(firefox)$"

        #   # Chrome-based browsers
        #   "size 70% 100%, class:^(google-chrome)$"
        #   "tile, class:^(google-chrome)$"
        #   "group set always, class:^(google-chrome)$"

        #   # IDEs and editors - generous space for productivity
        #   "size 80% 90%, class:^(code)$"
        #   "tile, class:^(code)$"
        #   "center, class:^(code)$"
        #   "group set always, class:^(code)$"

        #   "size 80% 90%, class:^(neovim)$"
        #   "tile, class:^(neovim)$"
        #   "group set always, class:^(neovim)$"

        #   "size 85% 95%, class:^(jetbrains-.*)$"
        #   "tile, class:^(jetbrains-.*)$"
        #   "center, class:^(jetbrains-.*)$"

        #   # Terminals - golden ratio proportions for elegance
        #   "size 61.8% 70%, class:^(kitty)$"
        #   "tile, class:^(kitty)$"
        #   "size 61.8% 70%, class:^(foot)$"
        #   "tile, class:^(foot)$"
        #   "size 61.8% 70%, class:^(com.mitchellh.ghostty)$"
        #   "tile, class:^(com.mitchellh.ghostty)$"
        #   "size 61.8% 70%, class:^(alacritty)$"
        #   "tile, class:^(alacritty)$"

        #   # Media applications - center stage
        #   "size 80% 80%, class:^(mpv)$"
        #   "center, class:^(mpv)$"
        #   "size 85% 85%, class:^(vlc)$"
        #   "center, class:^(vlc)$"

        #   # Communication apps - sidebar friendly
        #   "size 30% 80%, class:^(discord)$"
        #   "tile, class:^(discord)$"
        #   "size 30% 80%, class:^(slack)$"
        #   "tile, class:^(slack)$"
        #   "size 35% 85%, class:^(teams)$"
        #   "tile, class:^(teams)$"

        #   # File managers - explorer layout
        #   "size 65% 75%, class:^(thunar)$"
        #   "tile, class:^(thunar)$"
        #   "size 65% 75%, class:^(nautilus)$"
        #   "tile, class:^(nautilus)$"
        #   "size 65% 75%, class:^(dolphin)$"
        #   "tile, class:^(dolphin)$"

        #   # System utilities - compact and efficient
        #   "size 50% 60%, class:^(htop)$"
        #   "center, class:^(htop)$"
        #   "size 55% 65%, class:^(btop)$"
        #   "center, class:^(btop)$"

        #   ######## TAGS ########
        #   # "tag:+browser class:^(brave-browser)$"
        #   # "tag:+browser class:^(firefox)$"

        #   # "tag:+ide class:^(code)$"

        #   # "tag:+term class:^(kitty)$"
        #   # "tag:+term class:^(foot)$"
        #   # "tag:+term class:^(com.mitchellh.ghostty)$"

        #   "float, class:(clipse)"
        #   "size 622 652, class:(clipse)"
        #   "stayfocused, class:(clipse)"

        #   "float,class:($calculator)"
        #   "workspace special:special:calculator,class:($calculator)"
        #   "size 622 652, class:($calculator)"
        #   "stayfocused, class:($calculator)"

        #   "float,class:($passman)"
        #   "workspace special:special:passman,class:($passman)"
        #   "size 622 652, class:($passman)"
        #   "stayfocused, class:($passman)"

        #   "float,title:($resourceman)"
        #   "workspace special:special:resourceman,title:($resourceman)"
        #   "size 622 652, title:($resourceman)"
        #   "stayfocused, title:($resourceman)"

        #   "float,class:($obsidian)"
        #   "workspace special:special:obsidian,class:($obsidian)"
        #   "size 622 652, class:($obsidian)"
        #   # "workspace name:ide tag:^ide$"
        # ];

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
        rofi
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
