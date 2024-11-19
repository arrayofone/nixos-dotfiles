{
  pkgs,
  config,
  lib,
  ...
}: {
  options.hyprlock = {
    enable = lib.mkEnableOption "hyprlock";
  };

  config = lib.mkIf config.hyprlock.enable {
    home-manager.users.arrayofone = {
      home.packages = [pkgs.hyprlock];

      programs = {
        hyprlock = {
            enable = true;
        };
      };

      xdg.configFile."hypr/hyprlock.conf".text = ''
        general {
          disable_loading_bar = true
          hide_cursor = true
          grace = 0
          no_fade_in = false
          ignore_empty_input = true
        }

        background {
          path = ${./lockscreen.png}
          blur_size = 2
          blur_passes = 1
          contrast = 0.8916
          brightness = 0.8172
          vibrancy = 0.1696
          vibrancy_darkness = 0.0
        }

        input-field {
          size = 250, 60
          outline_thickness = 2
          dots_size = 0.2
          dots_spacing = 0.2
          dots_center = true
          outer_color = rgba(0, 0, 0, 0)
          inner_color = rgba(0, 0, 0, 0.5)
          font_color = rgb(200, 200, 200)
          fade_on_empty = false
          placeholder_text = <i>Keep it secret, keep it safe</i>
          hide_input = false
          position = 0,0
          halign = center
          valign = center
        }

        # label {
        #   font_family = Ubuntu
        #   text = Barad-dûr
        #   font_size = 25
        #   position = 0,0
        #   halign = center
        #   valign = center
        # }
      '';
    };
    security.pam.services.hyprlock = {};
  };
}