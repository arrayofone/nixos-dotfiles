{config, pkgs, lib, namespace, ...}: 
let
    cfg = config.${namespace}.hardware.nvidia;
in
{
  options.${namespace}.hardware.nvidia = {
    enable = lib.mkEnableOption "enable nvidia";
  };

  config = lib.mkIf cfg.enable {
    services.xserver.enable = true;
    services.xserver.videoDrivers = ["nvidia"];

    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;
      };

      nvidia = {
        modesetting.enable = true;
        powerManagement.enable = false;
        powerManagement.finegrained = false;
        open = true;
        nvidiaSettings = false;
        package = config.boot.kernelPackages.nvidiaPackages.beta;
      };
    };

    environment = {
      variables = {
        LIBVA_DRIVER_NAME = "nvidia";
        XDG_SESSION_TYPE = "wayland";
        GBM_BACKEND = "nvidia-drm";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        # __GL_GSYNC_ALLOWED = "1";
        __GL_VRR_ALLOWED = "0"; # Controls if Adaptive Sync should be used. Recommended to set as “0” to avoid having problems on some games.
        # QT_AUTO_SCREEN_SCALE_FACTOR = "1";
        # QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        # CUDA_CACHE_PATH = "$XDG_CACHE_HOME/nv";
      };

      sessionVariables = {
        NIXOS_OZONE_WL = "1"; # Hint electron apps to use wayland
        WLR_NO_HARDWARE_CURSORS = "1"; # Fix cursor rendering issue on wlr nvidia.
      };
      
      shellAliases = {
        nvidia-settings = "nvidia-settings --config='$XDG_CONFIG_HOME'/nvidia/settings";
      };
    };
  };
}
