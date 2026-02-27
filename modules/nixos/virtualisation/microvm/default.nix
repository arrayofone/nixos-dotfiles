# @gitian:module MicroVM host module — defines Firecracker-based virtual machines with
# typed option declarations (vcpus, memory, MAC, volumes). Each VM gets a TAP interface
# bridged to the host network. Used on helms-deep (aarch64-linux).
{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  cfg = config.${namespace}.virtualisation.microvm;

  vmType = lib.types.submodule {
    options = {
      vcpus = lib.mkOption {
        description = "Number of virtual CPUs";
        type = lib.types.int;
        default = 1;
      };

      memMiB = lib.mkOption {
        description = "Memory in MiB";
        type = lib.types.int;
        default = 512;
      };

      macAddress = lib.mkOption {
        description = "MAC address for the VM's TAP interface";
        type = lib.types.str;
      };

      volumes = lib.mkOption {
        description = "Block device volumes";
        type = lib.types.listOf (
          lib.types.submodule {
            options = {
              image = lib.mkOption {
                description = "Path to the volume image";
                type = lib.types.str;
              };
              sizeMiB = lib.mkOption {
                description = "Size in MiB";
                type = lib.types.int;
              };
            };
          }
        );
        default = [ ];
      };

      extraConfig = lib.mkOption {
        description = "Extra NixOS configuration merged into the VM";
        type = lib.types.attrs;
        default = { };
      };
    };
  };
in
{
  options.${namespace}.virtualisation.microvm = {
    enable = lib.mkEnableOption "microvm host with Firecracker VMs";

    bridgeInterface = lib.mkOption {
      description = "Bridge interface to attach TAP interfaces to";
      type = lib.types.str;
      default = "br0";
    };

    vms = lib.mkOption {
      description = "MicroVM definitions";
      type = lib.types.attrsOf vmType;
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    boot.kernelModules =
      if pkgs.stdenv.hostPlatform.isx86_64 then
        [
          "kvm-intel"
          "kvm-amd"
        ]
      else
        [ "kvm" ];

    microvm.vms = lib.mapAttrs (
      name: vm:
      {
        config = lib.mkMerge [
          {
            microvm = {
              hypervisor = "firecracker";
              vcpu = vm.vcpus;
              mem = vm.memMiB;

              interfaces = [
                {
                  type = "tap";
                  id = "vm-${name}";
                  mac = vm.macAddress;
                }
              ];

              volumes = map (vol: {
                image = vol.image;
                mountPoint = "/";
                size = vol.sizeMiB;
              }) vm.volumes;
            };

            networking.hostName = name;

            systemd.network.enable = true;
            networking.useNetworkd = true;
            systemd.network.networks."10-eth" = {
              matchConfig.Type = "ether";
              networkConfig.DHCP = "yes";
            };
          }
          vm.extraConfig
        ];
      }
    ) cfg.vms;

    systemd.network.networks = lib.mapAttrs' (
      name: _vm:
      lib.nameValuePair "20-vm-${name}" {
        matchConfig.Name = "vm-${name}";
        networkConfig.Bridge = cfg.bridgeInterface;
      }
    ) cfg.vms;
  };
}
