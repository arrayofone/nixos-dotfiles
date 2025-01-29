{ inputs, lib, pkgs, config, namespace, ... }:
let
  cfg = config.${namespace}.gui.desktop.sddm;
  theme = pkgs.${namespace}.sddm_theme;
in {
  options.${namespace}.gui.desktop.sddm = {
    enable = lib.mkEnableOption "sddm";
  };

  config = lib.mkIf cfg.enable {
    services.displayManager.sddm = {
      enable = true;
      package = pkgs.kdePackages.sddm;
      wayland = {
        enable = true;
        compositor = "weston";
      };
      theme = "${theme}";
      # settings = {
      #   Theme = {
      #     Current = "${theme}";
      #     ThemeDir = "${theme}";
      #   };
      # };
      # extraPackages = with pkgs.kdePackages; [qtquick];
      # theme = "${import pkgs.${namespace}.sddm_theme {inherit pkgs;}}";
      extraPackages = with pkgs.kdePackages; [
        pkgs.kdePackages.qt5compat
      ];
      #   breeze-icons
      #   kirigami
      #   libplasma
      #   plasma5support
      #   qtsvg
      #   qtvirtualkeyboard
      # ];
    };
  };
}
