{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
    cfg = config.${namespace}.hyprlock;
in
{
  options.${namespace}.hyprlock = {
    enable = lib.mkEnableOption "hyprlock";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.hyprlock];

    xdg.configFile."hypr/hyprlock.conf".text = ''
      general {
        disable_loading_bar = true
        hide_cursor = true
        grace = 0
        no_fade_in = false
        ignore_empty_input = true
      }

      background {
        path = ${../theme/theme/wallpapers/glacier.jpg}
        blur_size = 4
        blur_passes = 3
        contrast = 0.9
        brightness = 0.75
        vibrancy = 0.2
        vibrancy_darkness = 0.0
      }

      # Time
      label {
        text = cmd[update:1000] echo "$(date +"%H:%M")"
        color = rgba(232, 241, 250, 1.0)
        font_size = 90
        font_family = Ubuntu Sans
        position = 0, 280
        halign = center
        valign = center
        shadow_passes = 2
        shadow_size = 3
        shadow_color = rgba(0, 0, 0, 0.5)
      }

      # Date
      label {
        text = cmd[update:60000] echo "$(date +"%A, %B %d")"
        color = rgba(139, 158, 232, 0.9)
        font_size = 18
        font_family = Ubuntu Sans
        position = 0, 180
        halign = center
        valign = center
      }

      # Barad-dûr title
      label {
        text = ━━━━━━━━  𝔅𝔞𝔯𝔞𝔡-𝔡𝔲̂𝔯  ━━━━━━━━
        color = rgba(159, 232, 255, 1.0)
        font_size = 32
        font_family = Ubuntu Sans
        position = 0, 100
        halign = center
        valign = center
        shadow_passes = 3
        shadow_size = 5
        shadow_color = rgba(10, 16, 28, 0.8)
      }

      # Subtitle
      label {
        text = The Dark Tower of Mordor
        color = rgba(168, 188, 212, 0.7)
        font_size = 14
        font_family = Ubuntu Sans
        position = 0, 60
        halign = center
        valign = center
      }

      # Input field
      input-field {
        size = 300, 50
        outline_thickness = 3
        dots_size = 0.25
        dots_spacing = 0.25
        dots_center = true
        dots_rounding = -1
        # Ice → sapphire gradient ring, matching the Hyprland active border
        outer_color = rgba(159, 232, 255, 0.9) rgba(74, 144, 217, 0.9) 45deg
        inner_color = rgba(10, 16, 28, 0.85)
        font_color = rgba(232, 241, 250, 1.0)
        fade_on_empty = true
        fade_timeout = 1000
        placeholder_text = <span foreground="##9FE8FF"><i>Keep it secret, keep it safe...</i></span>
        hide_input = false
        rounding = 14
        check_color = rgba(127, 217, 185, 0.8)
        fail_color = rgba(230, 126, 138, 0.8)
        fail_text = <i>The way is shut</i>
        capslock_color = rgba(232, 206, 140, 0.8)
        position = 0, -50
        halign = center
        valign = center
        shadow_passes = 2
        shadow_size = 4
        shadow_color = rgba(0, 0, 0, 0.5)
      }

      # User info
      label {
        text =     $USER
        color = rgba(111, 216, 208, 0.9)
        font_size = 16
        font_family = Ubuntu Sans
        position = 0, -140
        halign = center
        valign = center
      }

      # Bottom quote
      label {
        text = "One does not simply walk into Mordor"
        color = rgba(70, 88, 122, 0.8)
        font_size = 14
        font_family = Ubuntu Sans
        position = 0, 30
        halign = center
        valign = bottom
      }
    '';
    # home = {
    #   security.pam.services.hyprlock = {};
    # };
  };
}