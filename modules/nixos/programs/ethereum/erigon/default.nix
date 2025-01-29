# {...}: {}
{config, lib, namespace, ...}:
let
    cfg = config.${namespace}.programs.ethereum.erigon;
in
{
  options.${namespace}.programs.ethereum.erigon = {
    sepolia = {
      enable = lib.mkEnableOption "enable erigon ethereum node";
      datadir = lib.mkOption {
        type = lib.types.str;
        default = "/var/ethereum/erigon/sepolia";
        description = ''
          Root path of the data dir for the erigon db and secrets.
        '';
        example = "/var/ethereum/erigon/sepolia";
      };
    };
  };

  config = lib.mkIf cfg.sepolia.enable {
    services.ethereum.erigon.sepolia = {
      enable = true;
      args = {
        datadir = "/var/ethereum/erigon/sepolia";
        port = 30303;
        snapshots = true;
        externalcl = false;
        chain = "sepolia";
        torrent.port = 42069;
        http = {
          enable = true;
          addr = "127.0.0.1";
          port = 8545;
          compression = false;
          corsdomain = ["localhost"];
          vhosts = ["localhost"];
          api = ["eth" "net"];
          trace = true;
          timeouts = {
            idle = "2m0s";
            read = "30s";
            write = "30m0s";
          };
        };
        ws = {
          enable = true;
          compression = false;
        };
        authrpc = {
          addr = "127.0.0.1";
          port = 8551;
          vhosts = ["localhost"];
          # jwtsecret = "${cfg.datadir}/sepolia/secrets";
          timeouts = {
            idle = "2m0s";
            read = "30s";
            write = "30m0s";
          };
        };
        private.api = {
          addr = "127.0.0.1:9090";
          ratelimit = 31872;
        };
        metrics = {
          enable = true;
          addr = "127.0.0.1";
          port = 6060;
        };
      };
    };
  };
}
