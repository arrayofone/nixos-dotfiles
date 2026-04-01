{
  config,
  namespace,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
  ];

  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = "nix-command flakes";
      trusted-users = [ "@wheel" ];
    };

    gc = {
      automatic = true;
      dates = [ "05:00" ];
    };
  };

  networking.hostName = "helms-deep";

  boot.loader = {
    grub.enable = false;
    generic-extlinux-compatible.enable = true;
  };

  snowfallorg.users.arrayofone = {
    create = true;
    admin = true;

    home = {
      enable = false;
    };
  };

  users = {
    groups.arrayofone = { };

    users.arrayofone = {
      isNormalUser = true;
      group = "arrayofone";
      hashedPasswordFile = config.sops.secrets."system/users/arrayofone/password".path;
      shell = pkgs.zsh;
      extraGroups = [ "wheel" ];
    };
  };

  fellowship = {
    bridge = {
      enable = true;
      subnet = "10.10.0.0/24";
      hostAddress = "10.10.0.1";
      dhcpRange = {
        start = "10.10.0.100";
        end = "10.10.0.200";
      };
      uplinkInterface = "eth0";
    };

    microvm = {
      enable = true;
      bridgeInterface = "br0";

      vms = {
        gondor = {
          vcpus = 2;
          memMiB = 2048;
          macAddress = "02:00:00:00:00:01";
          volumes = [
            {
              image = "gondor.img";
              sizeMiB = 20480;
            }
          ];
          extraConfig = {
            users.users.admin = {
              isNormalUser = true;
              extraGroups = [ "wheel" ];
              password = "changeme";
            };
            security.sudo.wheelNeedsPassword = false;
            services.openssh = {
              enable = true;
              settings.PermitRootLogin = "no";
            };
            environment.systemPackages = with pkgs; [
              vim
              htop
              curl
              git
            ];
            networking.firewall.enable = true;
          };
        };

        rohan = {
          vcpus = 2;
          memMiB = 1024;
          macAddress = "02:00:00:00:00:02";
          volumes = [
            {
              image = "rohan.img";
              sizeMiB = 10240;
            }
          ];
          extraConfig = {
            users.users.admin = {
              isNormalUser = true;
              extraGroups = [ "wheel" ];
              password = "changeme";
            };
            security.sudo.wheelNeedsPassword = false;
            services.openssh = {
              enable = true;
              settings.PermitRootLogin = "no";
            };
            environment.systemPackages = with pkgs; [
              vim
              curl
            ];
            networking.firewall = {
              enable = true;
              allowedTCPPorts = [ 22 ];
            };
          };
        };

        shire = {
          vcpus = 1;
          memMiB = 512;
          macAddress = "02:00:00:00:00:03";
          volumes = [
            {
              image = "shire.img";
              sizeMiB = 4096;
            }
          ];
          extraConfig = {
            services.blocky = {
              enable = true;
              settings = {
                ports = {
                  dns = 53;
                  http = 4000;
                };
                upstreams.groups.default = [
                  "https://one.one.one.one/dns-query"
                  "https://dns.google/dns-query"
                ];
                blocking = {
                  denylists = {
                    ads = [
                      "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
                    ];
                  };
                  clientGroupsBlock = {
                    default = [ "ads" ];
                  };
                };
              };
            };
            networking.firewall = {
              enable = true;
              allowedTCPPorts = [
                22
                53
                4000
              ];
              allowedUDPPorts = [ 53 ];
            };
            services.openssh = {
              enable = true;
              settings.PermitRootLogin = "no";
            };
            users.users.admin = {
              isNormalUser = true;
              extraGroups = [ "wheel" ];
              password = "changeme";
            };
            security.sudo.wheelNeedsPassword = false;
          };
        };
      };
    };
  };

  services.openssh.enable = true;

  programs.zsh.enable = true;

  nixpkgs.config.allowUnfree = true;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];
  };

  system.stateVersion = "24.05";

  i18n.defaultLocale = "en_CA.UTF-8";

  time.timeZone = "America/Vancouver";
}
