# {...}: {}
{ config, lib, namespace, inputs, system, ... }:
let cfg = config.${namespace}.programs.ethereum.geth;
in {
  options.${namespace}.programs.ethereum.geth = {
    sepolia = {
      enable = lib.mkEnableOption "enable geth ethereum node";
      datadir = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          Root path of the data dir for the geth db and secrets.
        '';
        example = "/srv/geth/sepolia";
      };
    };
  };

  config = lib.mkIf cfg.sepolia.enable {
    services.ethereum.geth.sepolia = {
      enable = true;
      extraArgs = [
        "--beacon.api"
        "http://unstable.sepolia.beacon-api.nimbus.team/"
        "--beacon.checkpoint"
        "0x1e2d4b981126f6ca6410722f9ded4cb87e4141bcf377e72205f68d26d2ee262a"
      ];
      openFirewall = false;
      package = inputs.ethereum-nix.outputs.packages.${system}.geth;
      # package = pkgs.geth;
      args = {
        datadir = cfg.sepolia.datadir;
        port = 30303;
        bootnodes = null;
        gcmode = "full"; # full | archive
        maxpeers = 50;
        netrestrict = null;
        network = "sepolia";
        networkid = 11155111;
        nodiscover = false;
        syncmode = "snap"; # "snap" | "fast" | "full" | "light"
        verbosity = 3;
        authrpc = {
          addr = "127.0.0.1";
          jwtsecret = null;
          port = 8551;
          vhosts = [ "localhost" ];
        };
        http = {
          enable = true;
          addr = "127.0.0.1";
          api = null;
          corsdomain = null;
          port = 8545;
          rpcprefix = null;
          vhosts = [ "localhost" ];
        };
        metrics = {
          enable = true;
          addr = "127.0.0.1";
          port = 6060;
        };
        ws = {
          enable = true;
          addr = "127.0.0.1";
          api = null;
          port = 8546;
        };
      };
      # backup = {
      #   enable = false;
      #   schedule = ;
      #   metadata = {
      #     interval = ;
      #   };
      #   btrfs = {
      #     enable = false;
      #     snapshotDirectory = ;
      #     snapshotRetention = ;
      #   };
      #   restic = {
      #     environmentFile = ;
      #     exclude = ;
      #     extraOptions = ;
      #     passwordFile = ;
      #     rcloneConfig = ;
      #     rcloneConfigFile = ;
      #     rcloneOptions = ;
      #     repository = ;
      #     repositoryFile = ;
      #   };
      # };
      # restore = {
      #   enable = false;
      #   snapshot = ;
      #   timeout = ;
      #   restic = {
      #     environmentFile = ;
      #     exclude = ;
      #     extraOptions = ;
      #     passwordFile = ;
      #     rcloneConfig = ;
      #     rcloneConfigFile = ;
      #     rcloneOptions = ;
      #     repository = ;
      #     repositoryFile = ;
      #   };
      # };
    };
  };
}
