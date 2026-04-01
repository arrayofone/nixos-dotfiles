{
  lib,
  config,
  pkgs,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.waybar;
in
{
  options.${namespace}.waybar = {
    enable = lib.mkEnableOption "waybar";
  };

  config = lib.mkIf cfg.enable {
    programs.waybar = {
      enable = true;
      systemd.enable = true;

      # Use external configuration files for better maintainability
      settings = {
        mainBar = {
          # Waybar configuration for Hyprland + Stylix + Catppuccin Mocha
          layer = "top";
          position = "top";
          height = 35;
          spacing = 4;
          margin-top = 10;
          margin-left = 15;
          margin-right = 15;
          margin-bottom = 0;

          # Module layout
          modules-left = [
            "hyprland/workspaces"
            "hyprland/submap"
          ];
          modules-center = [
            "hyprland/window"
          ];
          modules-right = [
            "tray"
            "custom/vpn"
            "idle_inhibitor"
            "pulseaudio"
            "network"
            "cpu"
            "memory"
            "temperature"
            "battery"
            "clock"
          ];

          # Hyprland workspaces
          "hyprland/workspaces" = {
            disable-scroll = true;
            all-outputs = true;
            warp-on-scroll = false;
            format = "{icon}";
            format-icons = {
              "1" = "󰲠";
              "2" = "󰲢";
              "3" = "󰲤";
              "4" = "󰲦";
              "5" = "󰲨";
              "6" = "󰲪";
              "7" = "󰲬";
              "8" = "󰲮";
              "9" = "󰲰";
              "10" = "󰿬";
              urgent = "󰀪";
              active = "󰮯";
              default = "󰧞";
            };
            persistent-workspaces = {
              "*" = 5;
            };
          };

          # Hyprland window title
          "hyprland/window" = {
            format = "{}";
            max-length = 60;
            separate-outputs = true;
            rewrite = {
              "(.*) — Mozilla Firefox" = "󰈹 $1";
              "(.*) - Visual Studio Code" = "󰨞 $1";
              "(.*) - vim" = " $1";
              "(.*) - nvim" = " $1";
              "(.*)Spotify" = "󰓇 $1";
              "(.*) - Discord" = "󰙯 $1";
            };
          };

          # Hyprland submap (keybind modes)
          "hyprland/submap" = {
            format = "󰌌 {}";
            max-length = 20;
            tooltip = false;
          };

          # System tray
          tray = {
            icon-size = 18;
            spacing = 8;
          };

          # Clock
          clock = {
            timezone = "America/Vancouver";
            tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
            format = "{:%H:%M}";
            format-alt = "{:%a, %b %d, %Y}";
            calendar = {
              mode = "year";
              mode-mon-col = 3;
              weeks-pos = "right";
              on-scroll = 1;
              format = {
                months = "<span color='#c6a0f6'><b>{}</b></span>";
                days = "<span color='#cad3f5'><b>{}</b></span>";
                weeks = "<span color='#8bd5ca'><b>W{}</b></span>";
                weekdays = "<span color='#f5a97f'><b>{}</b></span>";
                today = "<span color='#ed8796'><b><u>{}</u></b></span>";
              };
            };
          };

          # CPU usage
          cpu = {
            format = "󰻠 {usage}%";
            tooltip = false;
            interval = 2;
            states = {
              warning = 70;
              critical = 90;
            };
          };

          # Memory usage
          memory = {
            format = "󰍛 {}%";
            tooltip-format = "Memory: {used:0.1f}G/{total:0.1f}G\nSwap: {swapUsed:0.1f}G/{swapTotal:0.1f}G";
            interval = 2;
            states = {
              warning = 70;
              critical = 90;
            };
          };

          # Temperature monitoring
          temperature = {
            thermal-zone = 2;
            hwmon-path = [
              "/sys/class/hwmon/hwmon1/temp1_input"
              "/sys/class/hwmon/hwmon2/temp1_input"
            ];
            critical-threshold = 80;
            format-critical = "󰸁 {temperatureC}°C";
            format = "󰔏 {temperatureC}°C";
            tooltip = true;
            interval = 2;
          };

          # Battery status
          battery = {
            states = {
              good = 95;
              warning = 30;
              critical = 20;
            };
            format = "{icon} {capacity}%";
            format-charging = "󰂄 {capacity}%";
            format-plugged = "󰚥 {capacity}%";
            format-alt = "{icon} {time}";
            format-full = "󰁹 {capacity}%";
            format-icons = [
              "󰂎"
              "󰁺"
              "󰁻"
              "󰁼"
              "󰁽"
              "󰁾"
              "󰁿"
              "󰂀"
              "󰂁"
              "󰂂"
            ];
            tooltip-format = "{timeTo}, {capacity}% - {power}W";
          };

          # Network status
          network = {
            format-wifi = "󰤨 {signalStrength}%";
            format-ethernet = "󰈀 Connected";
            tooltip-format = "󰤨 {essid}\n󰈀 {ifname}\n󰩠 {ipaddr}/{cidr}\n󰚇 {frequency}MHz\n󰤨 {signalStrength}% ({signaldBm}dBm)";
            tooltip-format-ethernet = "󰈀 {ifname}\n󰩠 {ipaddr}/{cidr}\n󰕒 Up: {bandwidthUpOctets} Down: {bandwidthDownOctets}";
            format-linked = "󰤭 {ifname} (No IP)";
            format-disconnected = "󰤮 Disconnected";
            format-alt = "{ifname}: {ipaddr}/{cidr}";
            on-click-right = "nm-connection-editor";
          };

          # Audio control
          pulseaudio = {
            scroll-step = 5;
            format = "{icon} {volume}%";
            format-bluetooth = "󰂯 {icon} {volume}%";
            format-bluetooth-muted = "󰂲 ";
            format-muted = "󰖁 Muted";
            format-source = "󰍬 {volume}%";
            format-source-muted = "󰍭";
            format-icons = {
              headphone = "󰋋";
              hands-free = "󰏳";
              headset = "󰋎";
              phone = "󰏲";
              portable = "󰦧";
              car = "󰄋";
              default = [
                "󰕿"
                "󰖀"
                "󰕾"
              ];
            };
            on-click = "pavucontrol";
            on-click-right = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
            tooltip-format = "{desc}\nVolume: {volume}%";
          };

          # Idle inhibitor
          idle_inhibitor = {
            format = "{icon}";
            format-icons = {
              activated = "󰅶";
              deactivated = "󰾪";
            };
            tooltip-format-activated = "Idle inhibitor is active";
            tooltip-format-deactivated = "Idle inhibitor is inactive";
          };

          # WireGuard VPN toggle
          "custom/vpn" = {
            format = "{}";
            interval = 5;
            exec = ''
              if ip link show wg0 &>/dev/null; then
                echo '{"text": "󰌾", "tooltip": "VPN Connected (wg0)", "class": "connected"}'
              else
                echo '{"text": "󰿆", "tooltip": "VPN Disconnected", "class": "disconnected"}'
              fi
            '';
            return-type = "json";
            on-click = ''
              if ip link show wg0 &>/dev/null; then
                sudo systemctl stop wg-quick-wg0.service
              else
                sudo systemctl start wg-quick-wg0.service
              fi
            '';
          };
        };
      };

      style = ''
        /* Catppuccin Macchiato Palette */
        @define-color base #24273a;
        @define-color mantle #1e2030;
        @define-color crust #181926;
        @define-color surface0 #363a4f;
        @define-color surface1 #494d64;
        @define-color surface2 #5b6078;
        @define-color text #cad3f5;
        @define-color subtext0 #a5adcb;
        @define-color subtext1 #b8c0e0;
        @define-color lavender #b7bdf8;
        @define-color blue #8aadf4;
        @define-color sapphire #7dc4e4;
        @define-color sky #91d7e3;
        @define-color teal #8bd5ca;
        @define-color green #a6da95;
        @define-color yellow #eed49f;
        @define-color peach #f5a97f;
        @define-color maroon #ee99a0;
        @define-color red #ed8796;
        @define-color mauve #c6a0f6;
        @define-color pink #f5bde6;
        @define-color flamingo #f0c6c6;
        @define-color rosewater #f4dbd6;

        * {
          font-family: "Ubuntu Sans", "Ubuntu", "Font Awesome 6 Free", sans-serif;
          font-size: 14px;
          font-weight: 600;
          min-height: 0;
        }

        window#waybar {
          background: transparent;
        }

        window#waybar > box {
          background: alpha(@base, 0.85);
          border: 2px solid alpha(@surface1, 0.8);
          border-radius: 16px;
          margin: 0;
          padding: 0 8px;
        }

        tooltip {
          background: @mantle;
          border: 2px solid @mauve;
          border-radius: 12px;
        }

        tooltip label {
          color: @text;
          padding: 4px 8px;
        }

        /* Module styling */
        #workspaces,
        #window,
        #tray,
        #idle_inhibitor,
        #pulseaudio,
        #network,
        #cpu,
        #memory,
        #temperature,
        #battery,
        #clock {
          padding: 4px 12px;
          margin: 4px 2px;
          border-radius: 10px;
          background: alpha(@surface0, 0.6);
          color: @text;
          transition: all 0.3s ease;
        }

        /* Workspaces */
        #workspaces {
          background: transparent;
          padding: 0;
          margin: 4px 4px;
        }

        #workspaces button {
          padding: 4px 8px;
          margin: 0 2px;
          border-radius: 8px;
          background: alpha(@surface0, 0.5);
          color: @subtext0;
          border: none;
          transition: all 0.3s ease;
        }

        #workspaces button:hover {
          background: alpha(@surface1, 0.8);
          color: @text;
        }

        #workspaces button.active {
          background: linear-gradient(135deg, alpha(@mauve, 0.8), alpha(@lavender, 0.6));
          color: @base;
          font-weight: 800;
          text-shadow: 0 0 2px alpha(@base, 0.3);
        }

        #workspaces button.urgent {
          background: linear-gradient(135deg, @red, @maroon);
          color: @base;
          animation: pulse 1s ease-in-out infinite;
        }

        @keyframes pulse {
          0% { opacity: 1; }
          50% { opacity: 0.7; }
          100% { opacity: 1; }
        }

        /* Window title */
        #window {
          color: @lavender;
          font-weight: 500;
          background: alpha(@surface0, 0.4);
        }

        /* Submap */
        #submap {
          padding: 4px 14px;
          margin: 4px 2px;
          border-radius: 10px;
          background: linear-gradient(135deg, @mauve, @pink);
          color: @base;
          font-weight: 800;
          animation: breathe 2s ease-in-out infinite;
        }

        @keyframes breathe {
          0% { opacity: 1; }
          50% { opacity: 0.8; }
          100% { opacity: 1; }
        }

        /* System tray */
        #tray {
          background: alpha(@surface0, 0.4);
        }

        #tray > .passive {
          -gtk-icon-effect: dim;
        }

        #tray > .needs-attention {
          -gtk-icon-effect: highlight;
          background: alpha(@red, 0.3);
        }

        /* Idle inhibitor */
        #idle_inhibitor {
          color: @subtext0;
          background: alpha(@surface0, 0.4);
        }

        #idle_inhibitor.activated {
          color: @green;
          background: alpha(@green, 0.2);
        }

        /* VPN */
        #custom-vpn {
          color: @subtext0;
          background: alpha(@surface0, 0.4);
          padding: 4px 12px;
          margin: 4px 2px;
          border-radius: 10px;
          transition: all 0.3s ease;
        }

        #custom-vpn.connected {
          color: @green;
          background: alpha(@green, 0.2);
        }

        #custom-vpn.disconnected {
          color: @surface2;
          background: alpha(@surface0, 0.4);
        }

        #custom-vpn:hover {
          background: alpha(@surface1, 0.8);
        }

        /* Clock */
        #clock {
          color: @rosewater;
          background: linear-gradient(135deg, alpha(@mauve, 0.3), alpha(@surface0, 0.6));
          font-weight: 700;
          padding: 4px 16px;
        }

        /* CPU */
        #cpu {
          color: @blue;
          background: alpha(@blue, 0.15);
        }

        #cpu.warning {
          color: @yellow;
          background: alpha(@yellow, 0.2);
        }

        #cpu.critical {
          color: @red;
          background: alpha(@red, 0.2);
          animation: pulse 1s ease-in-out infinite;
        }

        /* Memory */
        #memory {
          color: @green;
          background: alpha(@green, 0.15);
        }

        #memory.warning {
          color: @yellow;
          background: alpha(@yellow, 0.2);
        }

        #memory.critical {
          color: @red;
          background: alpha(@red, 0.2);
          animation: pulse 1s ease-in-out infinite;
        }

        /* Temperature */
        #temperature {
          color: @yellow;
          background: alpha(@yellow, 0.15);
        }

        #temperature.critical {
          color: @red;
          background: alpha(@red, 0.25);
          animation: pulse 0.8s ease-in-out infinite;
        }

        /* Network */
        #network {
          color: @teal;
          background: alpha(@teal, 0.15);
        }

        #network.disconnected {
          color: @surface2;
          background: alpha(@surface0, 0.4);
        }

        #network.linked {
          color: @yellow;
          background: alpha(@yellow, 0.15);
        }

        /* Audio */
        #pulseaudio {
          color: @peach;
          background: alpha(@peach, 0.15);
        }

        #pulseaudio.muted {
          color: @surface2;
          background: alpha(@surface0, 0.4);
        }

        #pulseaudio.bluetooth {
          color: @blue;
          background: alpha(@blue, 0.15);
        }

        /* Battery */
        #battery {
          color: @green;
          background: alpha(@green, 0.15);
        }

        #battery.good {
          color: @green;
          background: alpha(@green, 0.15);
        }

        #battery.warning:not(.charging) {
          color: @yellow;
          background: alpha(@yellow, 0.2);
        }

        #battery.critical:not(.charging) {
          color: @red;
          background: linear-gradient(135deg, alpha(@red, 0.3), alpha(@maroon, 0.2));
          animation: pulse 1s ease-in-out infinite;
        }

        #battery.charging {
          color: @green;
          background: alpha(@green, 0.2);
        }

        #battery.plugged {
          color: @teal;
          background: alpha(@teal, 0.15);
        }

        /* Hover effects for all modules */
        #tray:hover,
        #idle_inhibitor:hover,
        #pulseaudio:hover,
        #network:hover,
        #cpu:hover,
        #memory:hover,
        #temperature:hover,
        #battery:hover,
        #clock:hover {
          background: alpha(@surface1, 0.8);
          border-radius: 10px;
        }
      '';
    };

    home = {
      packages = with pkgs; [
        waybar
        pavucontrol # Audio control GUI
        networkmanagerapplet # Network management

        # Additional utilities that waybar modules might use
        playerctl # Media player control
        brightnessctl # Brightness control
        wireplumber # Audio session manager
      ];
    };

    # Ensure waybar restarts when Hyprland restarts
    systemd.user.services.waybar = {
      Unit = {
        # Description = "Highly customizable Wayland bar for Sway and Wlroots based compositors";
        Documentation = "https://github.com/Alexays/Waybar/wiki";
        PartOf = [ "hyprland-session.target" ];
        After = [
          "hyprland-session.target"
          "time-sync.target"
        ];
        Requisite = [ "hyprland-session.target" ];
      };

      Service = {
        Type = "exec";
        ExecStart = "${pkgs.waybar}/bin/waybar";
        ExecReload = "${pkgs.coreutils}/bin/kill -SIGUSR2 $MAINPID";
        Restart = "on-failure";
        KillMode = "mixed";
      };

      Install = {
        WantedBy = [ "hyprland-session.target" ];
      };
    };
  };
}
