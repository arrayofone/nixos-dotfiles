{ lib, config, pkgs, ... }:
let
    cfg = config.main-user;
in
{
  options.main-user = {
    enable = lib.mkEnableOption "enable main user";
    
    userName = lib.mkOption {
      default = "arrayofone";
      description = ''
        username
      '';
    };

    description = lib.mkOption {
      default = "main-user";
      description = ''
        description
      '';
    };

    auto-login = lib.mkOption {
      default = false;
      description = ''
        enable auto-login
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    users = {
      groups.${cfg.userName} = {};
      
      users.${cfg.userName} = {
        isNormalUser = true;
        group = "${cfg.userName}";
        initialPassword = "letmein";
        description = "${cfg.description}";
        shell = pkgs.zsh;
        extraGroups = [
          "networkmanager" 
          "docker"
          "podman"
          "wheel"
          "libvirtd"
        ];
      };
    };
    
    services.displayManager.autoLogin = lib.mkIf cfg.auto-login {
      enable = true;
      user = "arrayofone";
    };
  };
}
