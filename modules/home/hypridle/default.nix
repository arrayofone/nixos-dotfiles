{
  lib,
  config,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.hypridle;
in
{
  options.${namespace}.hypridle = {
    enable = lib.mkEnableOption "hypridle";
  };

  config = lib.mkIf cfg.enable {
    services = {
      hypridle = {
        enable = true;
        settings = {
          general = {
            lock_cmd = "pidof hyprlock || hyprlock";
            before_sleep_cmd = "playerctl pause && loginctl lock-session";
            after_sleep_cmd = "hyprctl dispatch dpms on";
          };

          listener = [
            # Warning notification before lock (10 minutes)
            {
              timeout = 600;
              on-timeout = "notify-send \"The Eye of Sauron\" \"The darkness approaches...\" -h string:x-canonical-private-synchronous:idle -h int:value:30 -a \"Barad-dûr\" -u normal -t 30000 -i ${./eye.png}";
              on-resume = "notify-send \"The Eye of Sauron\" \"The light returns to Middle-earth\" -h string:x-canonical-private-synchronous:idle -a \"Barad-dûr\" -u low -t 8000 -i ${./eye.png}";
            }
            # Pause media before lock
            {
              timeout = 630;
              on-timeout = "playerctl pause";
            }
            # Lock session (10.5 minutes)
            {
              timeout = 630;
              on-timeout = "loginctl lock-session";
            }
            # Turn off displays (30 minutes)
            {
              timeout = 1800;
              on-timeout = "hyprctl dispatch dpms off";
              on-resume = "hyprctl dispatch dpms on";
            }
          ];
        };
      };
    };
  };
}
