# @gitian:module Rofi launcher with a hand-crafted "glacier-glass" rasi theme —
# centered translucent card (frosted by the Hyprland rofi layer_rule blur), pill
# input bar, and an ice→sapphire gradient selection row matching the window borders.
# Replaces the generic stylix rofi target, which is disabled in the theme module.
{
  lib,
  config,
  pkgs,
  namespace,
  ...
}:
let
  cfg = config.${namespace}.rofi;
in
{
  options.${namespace}.rofi = {
    enable = lib.mkEnableOption "rofi";
  };

  config = lib.mkIf cfg.enable {
    programs.rofi = {
      enable = true;
      font = "Ubuntu Sans 13";
      terminal = "ghostty";
      theme = ./glacier-glass.rasi;
      extraConfig = {
        modi = "drun,run";
        show-icons = true;
        icon-theme = "Papirus-Dark";
        display-drun = "󱓞";
        drun-display-format = "{name}";
      };
    };
  };
}
