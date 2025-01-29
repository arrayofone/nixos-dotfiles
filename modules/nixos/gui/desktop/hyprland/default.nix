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

    programs = {
      uwsm.enable = true;
      hyprland = {
        enable = true;
        withUWSM = true;
        package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
        portalPackage =
          inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
      };
    };

    services = {
      devmon.enable = false; # todo
      upower.enable = false; # todo
      displayManager = {
        sddm = {
          settings = {
            Wayland = {
              SessionDir = "${
                inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland
              }/share/wayland-sessions";
            };
          };
        };
      };
    };

    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      config = {
        common.default = [ "gtk" ];
        hyprland.default = [
          "gtk"
          "hyprland"
        ];
      };

      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };
  };
}
