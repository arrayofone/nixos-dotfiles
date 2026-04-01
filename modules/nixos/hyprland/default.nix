# @gitian:module NixOS Hyprland system module — enables Hyprland compositor at the system level,
# configures the Cachix binary cache, UWSM session launcher, SDDM Wayland session, and XDG portals.
# The home-manager Hyprland module handles window manager settings and keybindings.
{
  config,
  lib,
  inputs,
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
    nix.settings = {
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };

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
