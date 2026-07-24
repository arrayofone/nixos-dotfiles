{
  lib,
  config,
  pkgs,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.waybar;

  vpnControl = pkgs.writeShellApplication {
    name = "waybar-vpn-control";
    runtimeInputs = with pkgs; [
      iproute2
      libnotify
      coreutils
      util-linux
    ];
    text = ''
      set -u
      ACTION="''${1:-status}"
      FLAG_DIR="''${XDG_RUNTIME_DIR:-/tmp}"
      FAIL_FLAG="$FLAG_DIR/waybar-vpn-failed"
      PID_FLAG="$FLAG_DIR/waybar-vpn-connecting.pid"
      LOG_FILE="$FLAG_DIR/waybar-vpn.log"
      BUDGET=120
      # sudo'd commands must use these exact paths: the NOPASSWD sudoers rules
      # match on them, and sudo (NixOS sets no secure_path) would otherwise
      # resolve PATH to /nix/store binaries and demand a password — which fails
      # silently under waybar's TTY-less exec.
      SYSTEMCTL=/run/current-system/sw/bin/systemctl
      WG=/run/current-system/sw/bin/wg

      is_up() {
        ip link show wg0 >/dev/null 2>&1 || return 1
        # Interface exists but verify a handshake actually completed
        local ts
        ts=$(sudo "$WG" show wg0 latest-handshakes 2>/dev/null | head -1 | cut -f2)
        [ -n "$ts" ] && [ "$ts" != "0" ]
      }

      connecting_pid() {
        [ -f "$PID_FLAG" ] || return 1
        local pid
        pid=$(cat "$PID_FLAG" 2>/dev/null) || return 1
        [ -n "$pid" ] && kill -0 "$pid" 2>/dev/null && echo "$pid"
      }

      kill_connect() {
        local pid
        pid=$(connecting_pid) && kill -- "-$pid" 2>/dev/null
        rm -f "$PID_FLAG"
        timeout 5 sudo "$SYSTEMCTL" stop wg-quick-wg0.service 2>/dev/null || true
      }

      case "$ACTION" in
        status)
          if [ -f "$FAIL_FLAG" ]; then
            printf '%s\n' '{"text": "󱎘", "tooltip": "VPN disabled — right-click to reset", "class": "failed"}'
          elif connecting_pid >/dev/null; then
            printf '%s\n' '{"text": "󱎫", "tooltip": "VPN connecting… click to cancel", "class": "connecting"}'
          elif is_up; then
            printf '%s\n' '{"text": "󰌾", "tooltip": "VPN connected (wg0)", "class": "connected"}'
          else
            printf '%s\n' '{"text": "󰿆", "tooltip": "VPN disconnected", "class": "disconnected"}'
          fi
          ;;
        toggle)
          if [ -f "$FAIL_FLAG" ]; then
            : # disabled — use right-click to reset
          elif connecting_pid >/dev/null; then
            kill_connect
            notify-send -a vpn -t 3000 "VPN" "Cancelled" || true
          elif is_up; then
            sudo "$SYSTEMCTL" stop wg-quick-wg0.service
            rm -f "$PID_FLAG" "$FAIL_FLAG"
          else
            setsid -f "$0" connect >>"$LOG_FILE" 2>&1
          fi
          ;;
        reset)
          kill_connect
          rm -f "$FAIL_FLAG" "$PID_FLAG"
          notify-send -a vpn -t 3000 "VPN" "Reset — ready to connect" || true
          ;;
        connect)
          if connecting_pid >/dev/null; then exit 0; fi
          echo $$ > "$PID_FLAG"
          trap 'rm -f "$PID_FLAG"' EXIT
          rm -f "$FAIL_FLAG"

          notify-send -a vpn -t 3000 "VPN" "Connecting…" || true

          SECONDS=0
          delays=(5 10 20 30 30 30)
          attempt=0
          for delay in "''${delays[@]}"; do
            if [ "$SECONDS" -ge "$BUDGET" ]; then break; fi
            attempt=$((attempt + 1))
            timeout 15 sudo "$SYSTEMCTL" start wg-quick-wg0.service 2>/dev/null || true
            sleep 2
            if is_up; then
              notify-send -a vpn -t 3000 "VPN" "Connected" || true
              exit 0
            fi
            timeout 5 sudo "$SYSTEMCTL" stop wg-quick-wg0.service 2>/dev/null || true
            echo "[$(date -Iseconds)] attempt $attempt failed; sleeping ''${delay}s" >&2
            sleep "$delay"
          done

          timeout 5 sudo "$SYSTEMCTL" stop wg-quick-wg0.service 2>/dev/null || true
          touch "$FAIL_FLAG"
          notify-send -a vpn -u critical -t 8000 \
            "VPN" "Connection failed — button disabled. Right-click to reset." || true
          exit 1
          ;;
        *)
          echo "usage: $(basename "$0") {status|toggle|connect|reset}" >&2
          exit 2
          ;;
      esac
    '';
  };
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
          # Macchiato-glass three-island bar: workspaces+window | clock | system
          layer = "top";
          position = "top";
          height = 34;
          spacing = 0;
          margin-top = 10;
          margin-left = 16;
          margin-right = 16;
          margin-bottom = 0;

          # Module layout
          modules-left = [
            "hyprland/workspaces"
            "hyprland/submap"
            "hyprland/window"
          ];
          modules-center = [
            "clock"
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
          ];

          # Hyprland workspaces — icons keyed by the named workspaces
          # (term/ide/browser/social) with a dot fallback for numbered ones
          "hyprland/workspaces" = {
            disable-scroll = true;
            all-outputs = true;
            warp-on-scroll = false;
            format = "{icon}";
            format-icons = {
              term = "";
              ide = "󰅩";
              browser = "󰇧";
              social = "󰭹";
              urgent = "󰀪";
              default = "󰧞";
            };
          };

          # Hyprland window title
          "hyprland/window" = {
            format = "{}";
            max-length = 40;
            separate-outputs = true;
            rewrite = {
              "(.*) — Mozilla Firefox" = "󰈹 $1";
              "(.*) - Brave" = "󰇧 $1";
              "(.*) — Zed" = "󰅩 $1";
              "(.*) - vim" = " $1";
              "(.*) - nvim" = " $1";
              "(.*) - Slack" = "󰒱 $1";
              "(.*) - Obsidian(.*)" = "󱓧 $1";
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

          # WireGuard VPN toggle with backoff retry and auto-disable on failure
          "custom/vpn" = {
            format = "{}";
            interval = 2;
            exec = "${vpnControl}/bin/waybar-vpn-control status";
            return-type = "json";
            on-click = "${vpnControl}/bin/waybar-vpn-control toggle";
            on-click-right = "${vpnControl}/bin/waybar-vpn-control reset";
          };
        };
      };

      # Macchiato-glass: transparent bar, three frosted islands (Hyprland
      # layer_rule blurs the waybar namespace), state-only colors, gradient
      # reserved for the active workspace. Numerals set in IntoneMono.
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
          font-family: "Ubuntu Sans", "Symbols Nerd Font", "Font Awesome 6 Free", sans-serif;
          font-size: 13px;
          font-weight: 600;
          min-height: 0;
        }

        window#waybar {
          background: transparent;
          color: @text;
        }

        /* Glass islands */
        .modules-left,
        .modules-center,
        .modules-right {
          background: alpha(@mantle, 0.72);
          border: 1px solid alpha(@surface1, 0.55);
          border-radius: 17px;
          padding: 0 6px;
        }

        tooltip {
          background: alpha(@crust, 0.95);
          border: 1px solid alpha(@surface1, 0.8);
          border-radius: 12px;
        }

        tooltip label {
          color: @text;
          padding: 6px 10px;
        }

        /* Quiet module baseline — pills appear only for state */
        #window,
        #submap,
        #tray,
        #custom-vpn,
        #idle_inhibitor,
        #pulseaudio,
        #network,
        #cpu,
        #memory,
        #temperature,
        #battery,
        #clock {
          background: transparent;
          color: @subtext1;
          padding: 2px 10px;
          margin: 3px 1px;
          border-radius: 999px;
          transition: background-color 0.2s ease, color 0.2s ease;
        }

        /* Mono numerals for the system cluster and clock */
        #pulseaudio,
        #network,
        #cpu,
        #memory,
        #temperature,
        #battery,
        #clock {
          font-family: "IntoneMono Nerd Font Mono", "IntoneMono Nerd Font", "Ubuntu Sans", monospace;
          font-weight: 500;
        }

        /* Workspaces */
        #workspaces {
          background: transparent;
          padding: 0 2px;
          margin: 3px 0;
        }

        #workspaces button {
          padding: 2px 10px;
          margin: 0 2px;
          border-radius: 999px;
          background: transparent;
          color: alpha(@subtext0, 0.75);
          border: none;
          font-size: 15px;
          transition: background-color 0.2s ease, color 0.2s ease;
        }

        #workspaces button:hover {
          background: alpha(@surface0, 0.85);
          color: @text;
        }

        #workspaces button.active {
          background: linear-gradient(135deg, alpha(@mauve, 0.95), alpha(@teal, 0.8), alpha(@blue, 0.95));
          color: @crust;
          padding: 2px 16px;
        }

        #workspaces button.urgent {
          background: linear-gradient(135deg, @red, @maroon);
          color: @crust;
          animation: pulse 1s ease-in-out infinite;
        }

        @keyframes pulse {
          0% { opacity: 1; }
          50% { opacity: 0.65; }
          100% { opacity: 1; }
        }

        /* Window title */
        #window {
          color: @subtext0;
          font-weight: 500;
        }

        /* Submap — the one loud element besides the active workspace */
        #submap {
          background: linear-gradient(135deg, @mauve, @pink);
          color: @crust;
          font-weight: 800;
          padding: 2px 14px;
          animation: breathe 2s ease-in-out infinite;
        }

        @keyframes breathe {
          0% { opacity: 1; }
          50% { opacity: 0.8; }
          100% { opacity: 1; }
        }

        /* Clock — center island */
        #clock {
          color: @mauve;
          font-weight: 700;
          font-size: 14px;
          padding: 2px 18px;
        }

        /* System tray */
        #tray {
          padding: 2px 8px;
        }

        #tray > .passive {
          -gtk-icon-effect: dim;
        }

        #tray > .needs-attention {
          -gtk-icon-effect: highlight;
          background: alpha(@red, 0.25);
          border-radius: 999px;
        }

        /* State colors only */
        #custom-vpn.connected { color: @teal; }
        #custom-vpn.connecting { color: @peach; }
        #custom-vpn.disconnected { color: alpha(@subtext0, 0.5); }
        #custom-vpn.failed { color: @red; }

        #idle_inhibitor.activated { color: @peach; }

        #pulseaudio.muted { color: alpha(@subtext0, 0.5); }
        #pulseaudio.bluetooth { color: @blue; }

        #network.disconnected { color: @red; }
        #network.linked { color: @yellow; }

        #cpu.warning,
        #memory.warning,
        #battery.warning:not(.charging) {
          color: @yellow;
          background: alpha(@yellow, 0.15);
        }

        #cpu.critical,
        #memory.critical,
        #temperature.critical,
        #battery.critical:not(.charging) {
          color: @red;
          background: alpha(@red, 0.18);
          animation: pulse 1s ease-in-out infinite;
        }

        #battery.charging,
        #battery.plugged {
          color: @green;
        }

        /* Hover */
        #tray:hover,
        #custom-vpn:hover,
        #idle_inhibitor:hover,
        #pulseaudio:hover,
        #network:hover,
        #cpu:hover,
        #memory:hover,
        #temperature:hover,
        #battery:hover,
        #clock:hover {
          background: alpha(@surface0, 0.8);
          color: @text;
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
