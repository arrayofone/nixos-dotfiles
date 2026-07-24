# @gitian:module Home-manager Hyprland config — comprehensive window manager settings
# including dwindle/master layouts (golden-ratio splits), animations, keybindings,
# workspace rules, and special workspaces for calculator/password-manager/notes.
# Written as a Lua config (configType = "lua") for Hyprland >= 0.56, which dropped
# hyprlang support on master; settings attrs render as hl.*(...) calls.
{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.hyprland;

  lua = lib.generators.mkLuaInline;

  # hl.bind("MODS + key", <dispatcher>) / hl.bind(..., { mouse/locked/repeating })
  mkBind = keys: dsp: { _args = [ keys (lua dsp) ]; };
  mkBindWith = keys: dsp: flags: { _args = [ keys (lua dsp) flags ]; };
  mkEnv = name: value: { _args = [ name value ]; };
  mkBezier = name: points: {
    _args = [
      name
      {
        type = "bezier";
        inherit points;
      }
    ];
  };

  terminal = "ghostty";
  browser = "brave";
  calculator = "qalculate-gtk";
  fileManager = "thunar";
  ide = "zeditor";
  menu = "rofi -show drun -show-icons";
  mainMod = "SUPER";
  passman = "proton-pass";
  obsidianApp = "obsidian";
  resourceman = "btop";

  ws_1 = "name:term";
  ws_2 = "name:ide";
  ws_3 = "name:browser";
  ws_4 = "name:social";
in
{
  options.${namespace}.hyprland = {
    enable = lib.mkEnableOption "hyprland";
  };

  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      configType = "lua";
      plugins = [ ];
      xwayland = {
        enable = true;
      };

      package = null;
      portalPackage = null;

      settings = {
        monitor = [
          {
            output = "";
            mode = "highres";
            position = "auto";
            scale = 1;
          }
        ];

        env = [
          # Cursor
          (mkEnv "XCURSOR_SIZE" "24")
          (mkEnv "XCURSOR_THEME" "Bibata-Modern-Ice")
          (mkEnv "HYPRCURSOR_SIZE" "24")
          (mkEnv "HYPRCURSOR_THEME" "Bibata-Modern-Ice")

          # Electron/Chromium Wayland
          (mkEnv "ELECTRON_OZONE_PLATFORM_HINT" "auto")
          (mkEnv "NIXOS_OZONE_WL" "1")

          # XDG Desktop
          (mkEnv "XDG_CURRENT_DESKTOP" "Hyprland")
          (mkEnv "XDG_SESSION_DESKTOP" "Hyprland")
          (mkEnv "XDG_SESSION_TYPE" "wayland")

          # Qt theming
          (mkEnv "QT_QPA_PLATFORM" "wayland;xcb")
          (mkEnv "QT_QPA_PLATFORMTHEME" "kvantum")
          (mkEnv "QT_WAYLAND_DISABLE_WINDOWDECORATION" "1")
          (mkEnv "QT_AUTO_SCREEN_SCALE_FACTOR" "1")

          # GTK
          (mkEnv "GDK_BACKEND" "wayland,x11,*")
          (mkEnv "GTK_THEME" "Catppuccin-Macchiato-Standard-Mauve-Dark")
        ];

        # "curve" is in home-manager's default importantPrefixes, so these
        # render ahead of the hl.animation calls that reference them.
        curve = [
          # Smooth and snappy
          (mkBezier "smoothOut" [ [ 0.36 0 ] [ 0.66 (-0.56) ] ])
          (mkBezier "smoothIn" [ [ 0.25 1 ] [ 0.5 1 ] ])
          (mkBezier "overshot" [ [ 0.05 0.9 ] [ 0.1 1.1 ] ])

          # Fluent design inspired
          (mkBezier "fluent_decel" [ [ 0.1 1 ] [ 0 1 ] ])
          (mkBezier "easeOutCirc" [ [ 0 0.55 ] [ 0.45 1 ] ])
          (mkBezier "easeOutCubic" [ [ 0.33 1 ] [ 0.68 1 ] ])
          (mkBezier "easeInOutQuart" [ [ 0.76 0 ] [ 0.24 1 ] ])

          # Elastic and bouncy
          (mkBezier "elastic" [ [ 0.68 (-0.6) ] [ 0.32 1.6 ] ])
          (mkBezier "bounce" [ [ 0.175 0.885 ] [ 0.32 1.275 ] ])

          # Utility
          (mkBezier "linear" [ [ 0 0 ] [ 1 1 ] ])
          (mkBezier "quick" [ [ 0.15 0 ] [ 0.1 1 ] ])
        ];

        animation = [
          { leaf = "global"; enabled = true; speed = 6; bezier = "default"; }

          # Border animations - rotating gradient
          { leaf = "border"; enabled = true; speed = 8; bezier = "fluent_decel"; }
          { leaf = "borderangle"; enabled = true; speed = 100; bezier = "linear"; style = "loop"; }

          # Window animations
          { leaf = "windows"; enabled = true; speed = 5; bezier = "overshot"; style = "popin 80%"; }
          { leaf = "windowsIn"; enabled = true; speed = 5; bezier = "bounce"; style = "popin 80%"; }
          { leaf = "windowsOut"; enabled = true; speed = 4; bezier = "smoothOut"; style = "popin 80%"; }
          { leaf = "windowsMove"; enabled = true; speed = 5; bezier = "overshot"; style = "slide"; }

          # Fade animations
          { leaf = "fadeIn"; enabled = true; speed = 4; bezier = "smoothIn"; }
          { leaf = "fadeOut"; enabled = true; speed = 4; bezier = "smoothOut"; }
          { leaf = "fade"; enabled = true; speed = 6; bezier = "smoothIn"; }
          { leaf = "fadeDim"; enabled = true; speed = 6; bezier = "smoothIn"; }
          { leaf = "fadeShadow"; enabled = true; speed = 6; bezier = "smoothIn"; }

          # Layer animations (rofi, waybar, etc.)
          { leaf = "layers"; enabled = true; speed = 4; bezier = "smoothIn"; style = "fade"; }
          { leaf = "layersIn"; enabled = true; speed = 4; bezier = "bounce"; style = "slide"; }
          { leaf = "layersOut"; enabled = true; speed = 3; bezier = "smoothOut"; style = "slide"; }

          # Workspace animations
          { leaf = "workspaces"; enabled = true; speed = 5; bezier = "overshot"; style = "slide"; }
          { leaf = "workspacesIn"; enabled = true; speed = 5; bezier = "bounce"; style = "slidefade 20%"; }
          { leaf = "workspacesOut"; enabled = true; speed = 5; bezier = "smoothOut"; style = "slidefade 20%"; }
          { leaf = "specialWorkspace"; enabled = true; speed = 4; bezier = "bounce"; style = "slidevert"; }
        ];

        config = {
          general = {
            border_size = 3;
            gaps_in = 6;
            gaps_out = 16;
            float_gaps = 0;
            gaps_workspaces = 50;

            # Catppuccin Macchiato gradient border
            col = {
              inactive_border = lib.mkDefault "rgba(363a4f88)";
              active_border = lib.mkDefault {
                colors = [
                  "rgba(c6a0f6ff)"
                  "rgba(8bd5caff)"
                  "rgba(8aadf4ff)"
                ];
                angle = 45;
              };
              nogroup_border = lib.mkDefault "rgba(494d6488)";
              nogroup_border_active = lib.mkDefault "rgba(ed8796ff)";
            };

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
              color = lib.mkDefault "rgba(1a1a2ecc)";
              color_inactive = lib.mkDefault "rgba(1a1a2e99)";
              offset = "0 12";
              scale = 0.95;
            };
          };

          animations = {
            enabled = true;
            workspace_wraparound = false;
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
              tap_to_click = true;
              drag_lock = 2;
              tap_and_drag = true;
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
            col = {
              border_active = lib.mkDefault "rgba(c6a0f6ff)";
              border_inactive = lib.mkDefault "rgba(494d6488)";
              border_locked_active = lib.mkDefault "rgba(ed8796ff)";
              border_locked_inactive = lib.mkDefault "rgba(5b607888)";
            };

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
              col = {
                active = lib.mkDefault "rgba(c6a0f6cc)";
                inactive = lib.mkDefault "rgba(363a4fcc)";
                locked_active = lib.mkDefault "rgba(ed8796cc)";
                locked_inactive = lib.mkDefault "rgba(494d64cc)";
              };
              gaps_in = 3;
              gaps_out = 3;
              keep_upper_gap = true;
            };
          };

          misc = {
            disable_hyprland_logo = true;
            disable_splash_rendering = true;
            col = {
              splash = "rgba(c6a0f6ff)";
            };
            font_family = lib.mkDefault "Ubuntu";
            splash_font_family = "Ubuntu Sans";
            force_default_wallpaper = 0;
            # vfr = true;
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

          debug = {
            overlay = false;
            damage_blink = false;
            disable_logs = true;
            disable_time = true;
            damage_tracking = 2;
            enable_stdout_logs = false;
            manual_crash = 0;
            suppress_errors = false;
            disable_scale_checks = false;
            error_limit = 5;
            error_position = 0;
            colored_stdout_logs = true;
            pass = false;
            full_cm_proto = false;
          };

          dwindle = {
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
        };

        device = {
          name = "epic-mouse-v1";
          sensitivity = -0.5;
        };

        bind = [
          (mkBind "${mainMod} + space" ''hl.dsp.exec_cmd("${menu}")'')
          (mkBind "${mainMod} + T" ''hl.dsp.exec_cmd("${terminal}")'')
          (mkBind "${mainMod} + Q" ''hl.dsp.window.close()'')
          (mkBind "${mainMod} + F" ''hl.dsp.window.float({ action = "toggle" })'')
          (mkBind "${mainMod} + E" ''hl.dsp.exec_cmd("${fileManager}")'')
          (mkBind "${mainMod} + S" ''hl.dsp.exec_cmd("shotman -c region -C")'')
          (mkBind "${mainMod} + D" ''hl.dsp.exec_cmd("GDK_BACKEND=x11 dbeaver")'')

          (mkBind "${mainMod} + M" ''hl.dsp.exit()'')
          (mkBind "${mainMod} + P" ''hl.dsp.window.pseudo()'')
          (mkBind "${mainMod} + L" ''hl.dsp.exec_cmd("${pkgs.hyprlock}/bin/hyprlock")'')

          (mkBind "${mainMod} + ALT + M" ''hl.dsp.exec_cmd("reboot")'')

          (mkBind "${mainMod} + left" ''hl.dsp.focus({ direction = "left" })'')
          (mkBind "${mainMod} + right" ''hl.dsp.focus({ direction = "right" })'')
          (mkBind "${mainMod} + up" ''hl.dsp.focus({ direction = "up" })'')
          (mkBind "${mainMod} + down" ''hl.dsp.focus({ direction = "down" })'')

          (mkBind "${mainMod} + 1" ''hl.dsp.focus({ workspace = "${ws_1}" })'')
          (mkBind "${mainMod} + 2" ''hl.dsp.focus({ workspace = "${ws_2}" })'')
          (mkBind "${mainMod} + 3" ''hl.dsp.focus({ workspace = "${ws_3}" })'')
          (mkBind "${mainMod} + 4" ''hl.dsp.focus({ workspace = "${ws_4}" })'')
          (mkBind "${mainMod} + 5" ''hl.dsp.focus({ workspace = 5 })'')
          (mkBind "${mainMod} + 6" ''hl.dsp.focus({ workspace = 6 })'')
          (mkBind "${mainMod} + 7" ''hl.dsp.focus({ workspace = 7 })'')
          (mkBind "${mainMod} + 8" ''hl.dsp.focus({ workspace = 8 })'')
          (mkBind "${mainMod} + 9" ''hl.dsp.focus({ workspace = 9 })'')
          (mkBind "${mainMod} + 0" ''hl.dsp.focus({ workspace = 10 })'')

          (mkBind "${mainMod} + SHIFT + 1" ''hl.dsp.window.move({ workspace = "${ws_1}" })'')
          (mkBind "${mainMod} + SHIFT + 2" ''hl.dsp.window.move({ workspace = "${ws_2}" })'')
          (mkBind "${mainMod} + SHIFT + 3" ''hl.dsp.window.move({ workspace = "${ws_3}" })'')
          (mkBind "${mainMod} + SHIFT + 4" ''hl.dsp.window.move({ workspace = "${ws_4}" })'')
          (mkBind "${mainMod} + SHIFT + 5" ''hl.dsp.window.move({ workspace = 5 })'')
          (mkBind "${mainMod} + SHIFT + 6" ''hl.dsp.window.move({ workspace = 6 })'')
          (mkBind "${mainMod} + SHIFT + 7" ''hl.dsp.window.move({ workspace = 7 })'')
          (mkBind "${mainMod} + SHIFT + 8" ''hl.dsp.window.move({ workspace = 8 })'')
          (mkBind "${mainMod} + SHIFT + 9" ''hl.dsp.window.move({ workspace = 9 })'')
          (mkBind "${mainMod} + SHIFT + 0" ''hl.dsp.window.move({ workspace = 10 })'')

          # Special workspaces: on_created_empty workspace rules spawn the app,
          # so a plain toggle replaces the old pgrep/hyprctl shell dance
          (mkBind "${mainMod} + SHIFT + Q" ''hl.dsp.workspace.toggle_special("calculator")'')
          (mkBind "${mainMod} + SHIFT + P" ''hl.dsp.workspace.toggle_special("passman")'')
          (mkBind "${mainMod} + SHIFT + R" ''hl.dsp.workspace.toggle_special("resourceman")'')
          (mkBind "${mainMod} + SHIFT + O" ''hl.dsp.workspace.toggle_special("obsidian")'')

          (mkBind "${mainMod} + mouse_down" ''hl.dsp.focus({ workspace = "e+1" })'')
          (mkBind "${mainMod} + mouse_up" ''hl.dsp.focus({ workspace = "e-1" })'')

          # Mouse binds (previously bindm)
          (mkBindWith "${mainMod} + mouse:272" ''hl.dsp.window.drag()'' { mouse = true; })
          (mkBindWith "${mainMod} + mouse:273" ''hl.dsp.window.resize()'' { mouse = true; })

          # Media/brightness keys (previously bindel)
          (mkBindWith "XF86AudioRaiseVolume" ''hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+")'' {
            locked = true;
            repeating = true;
          })
          (mkBindWith "XF86AudioLowerVolume" ''hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-")'' {
            locked = true;
            repeating = true;
          })
          (mkBindWith "XF86AudioMute" ''hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")'' {
            locked = true;
            repeating = true;
          })
          (mkBindWith "XF86AudioMicMute" ''hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle")'' {
            locked = true;
            repeating = true;
          })
          (mkBindWith "XF86MonBrightnessUp" ''hl.dsp.exec_cmd("brightnessctl s 10%+")'' {
            locked = true;
            repeating = true;
          })
          (mkBindWith "XF86MonBrightnessDown" ''hl.dsp.exec_cmd("brightnessctl s 10%-")'' {
            locked = true;
            repeating = true;
          })

          # Media player keys (previously bindl)
          (mkBindWith "XF86AudioNext" ''hl.dsp.exec_cmd("playerctl next")'' { locked = true; })
          (mkBindWith "XF86AudioPause" ''hl.dsp.exec_cmd("playerctl play-pause")'' { locked = true; })
          (mkBindWith "XF86AudioPlay" ''hl.dsp.exec_cmd("playerctl play-pause")'' { locked = true; })
          (mkBindWith "XF86AudioPrev" ''hl.dsp.exec_cmd("playerctl previous")'' { locked = true; })
        ];

        workspace_rule = [
          {
            workspace = ws_1;
            monitor = "DP-1";
            default = true;
          }
          {
            workspace = ws_2;
            monitor = "DP-2";
            default = true;
          }
          {
            workspace = ws_3;
            monitor = "DP-2";
            default = true;
          }
          {
            workspace = ws_4;
            monitor = "DP-2";
            default = true;
          }

          {
            workspace = "special:calculator";
            on_created_empty = "[float; size 622 652] ${calculator}";
          }
          {
            workspace = "special:passman";
            on_created_empty = "[float; size 622 652] ${passman}";
          }
          {
            workspace = "special:resourceman";
            on_created_empty = "${terminal} -e ${resourceman}";
          }
          {
            workspace = "special:obsidian";
            on_created_empty = "${obsidianApp}";
          }
        ];

        # Glass surfaces: blur the layer-shell UI (waybar islands, rofi card,
        # dunst notifications) so their translucent backgrounds frost the
        # content behind them. ignore_alpha keeps fully-transparent regions
        # (bar gaps, rounded corners) from blurring.
        layer_rule = [
          {
            match = {
              namespace = "waybar";
            };
            blur = true;
            ignore_alpha = 0.28;
          }
          {
            match = {
              namespace = "rofi";
            };
            blur = true;
            ignore_alpha = 0.28;
          }
          {
            match = {
              namespace = "dunst";
            };
            blur = true;
            ignore_alpha = 0.28;
          }
        ];

        on = {
          _args = [
            "hyprland.start"
            (lua ''
              function()
                hl.exec_cmd("nm-applet --indicator")
                hl.exec_cmd("clipse -listen")

                hl.exec_cmd("[workspace ${ws_1} silent] ${terminal}")
                hl.exec_cmd("[workspace ${ws_2} silent] ${ide}")
                hl.exec_cmd("[workspace ${ws_3} silent] ${browser}")
                hl.exec_cmd("[workspace ${ws_4} silent] slack")
              end'')
          ];
        };
      };

      systemd = {
        enable = true;
        variables = [ "--all" ];
      };
    };

    home = {
      packages = with pkgs; [
        networkmanagerapplet
        brightnessctl
        playerctl
      ];
    };
  };
}
