{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:

let
  cfg = config.${namespace}.programs.k3s;
in
{
  options.${namespace}.programs.k3s = {
    enable = lib.mkEnableOption "k3s lightweight Kubernetes cluster";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.k3s;
      description = "The k3s package to use.";
    };

    role = lib.mkOption {
      type = lib.types.enum [
        "server"
        "agent"
      ];
      default = "server";
      description = "Whether to run k3s as a server (control plane) or agent (worker).";
    };

    serverAddr = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "The k3s server address for agent mode. Leave null for server mode.";
      example = "https://10.0.0.1:6443";
    };

    tokenFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Path to file containing k3s cluster token.";
      example = "/etc/secrets/k3s-token";
    };

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/rancher/k3s";
      description = "k3s data directory.";
    };

    clusterInit = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Initialize a new cluster (for the first server in an HA setup).";
    };

    extraFlags = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Additional flags to pass to k3s.";
      example = [
        "--disable=traefik"
        "--write-kubeconfig-mode=644"
      ];
    };

    disableComponents = lib.mkOption {
      type = lib.types.listOf (
        lib.types.enum [
          "traefik"
          "servicelb"
          "metrics-server"
          "local-storage"
          "coredns"
        ]
      );
      default = [ ];
      description = "List of k3s components to disable.";
      example = [ "traefik" ];
    };

    networking = {
      clusterCIDR = lib.mkOption {
        type = lib.types.str;
        default = "10.42.0.0/16";
        description = "Network CIDR for pod IPs.";
      };

      serviceCIDR = lib.mkOption {
        type = lib.types.str;
        default = "10.43.0.0/16";
        description = "Network CIDR for service IPs.";
      };

      clusterDNS = lib.mkOption {
        type = lib.types.str;
        default = "10.43.0.10";
        description = "IP address for cluster DNS service.";
      };

      flannelBackend = lib.mkOption {
        type = lib.types.enum [
          "vxlan"
          "ipsec"
          "host-gw"
          "wireguard-native"
        ];
        default = "vxlan";
        description = "Flannel backend to use.";
      };
    };

    manifests = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      description = "Kubernetes manifests to auto-deploy.";
      example = lib.literalExpression ''
        {
          "hello-world" = '''
            apiVersion: v1
            kind: Namespace
            metadata:
              name: hello
          ''';
        }
      '';
    };

    kubeconfigMode = lib.mkOption {
      type = lib.types.str;
      default = "0644";
      description = "File mode for the generated kubeconfig.";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Open required ports in the firewall.";
    };
  };

  config = lib.mkIf cfg.enable {
    # Assertions
    assertions = [
      {
        assertion = cfg.role == "agent" -> cfg.serverAddr != null;
        message = "serverAddr must be set when running k3s in agent mode";
      }
      {
        assertion = cfg.role == "agent" -> cfg.tokenFile != null;
        message = "tokenFile must be set when running k3s in agent mode";
      }
    ];

    # Required kernel modules
    boot.kernelModules = [
      "overlay"
      "br_netfilter"
      "ip_tables"
      "ip6_tables"
      "iptable_nat"
      "iptable_mangle"
      "iptable_filter"
    ];

    # Kernel parameters for containers
    boot.kernel.sysctl = {
      "net.bridge.bridge-nf-call-iptables" = 1;
      "net.bridge.bridge-nf-call-ip6tables" = 1;
      "net.ipv4.ip_forward" = 1;
      "net.ipv6.conf.all.forwarding" = 1;
      "fs.inotify.max_user_watches" = 524288;
      "fs.inotify.max_user_instances" = 512;
      "vm.max_map_count" = 262144;
    };

    # Firewall configuration
    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [
        6443 # Kubernetes API server
        10250 # Kubelet metrics
      ]
      ++ lib.optionals (cfg.role == "server") [
        2379 # etcd client
        2380 # etcd peer
      ];

      allowedUDPPorts = [
        8472 # Flannel VXLAN
      ];

      allowedTCPPortRanges = [
        {
          from = 30000;
          to = 32767;
        } # NodePort services
      ];

      trustedInterfaces = [
        "cni+"
        "flannel+"
      ];
    };

    # Create k3s directories
    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir} 0755 root root -"
      "d ${cfg.dataDir}/server 0755 root root -"
      "d ${cfg.dataDir}/server/manifests 0755 root root -"
      "d /etc/rancher 0755 root root -"
      "d /etc/rancher/k3s 0755 root root -"
    ];

    # Install k3s package and tools
    environment.systemPackages = with pkgs; [
      cfg.package
      kubectl
      kubernetes-helm
    ];

    # k3s service
    systemd.services.k3s = {
      description = "k3s - Lightweight Kubernetes";
      documentation = [ "https://k3s.io" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "notify";
        NotifyAccess = "all";
        KillMode = "mixed";
        Restart = "on-failure";
        RestartSec = "5s";
        User = "root";
        Group = "root";

        ExecStart =
          let
            disableFlags = map (c: "--disable=${c}") cfg.disableComponents;

            serverFlags =
              lib.optionals (cfg.role == "server") [
                "--data-dir=${cfg.dataDir}"
                "--cluster-cidr=${cfg.networking.clusterCIDR}"
                "--service-cidr=${cfg.networking.serviceCIDR}"
                "--cluster-dns=${cfg.networking.clusterDNS}"
                "--flannel-backend=${cfg.networking.flannelBackend}"
                "--write-kubeconfig-mode=${cfg.kubeconfigMode}"
              ]
              ++ lib.optional cfg.clusterInit "--cluster-init";

            agentFlags = lib.optionals (cfg.role == "agent") [
              "--server=${cfg.serverAddr}"
            ];

            tokenFlag = lib.optional (cfg.tokenFile != null) "--token-file=${cfg.tokenFile}";

            allFlags = serverFlags ++ agentFlags ++ tokenFlag ++ disableFlags ++ cfg.extraFlags;
          in
          "${cfg.package}/bin/k3s ${cfg.role} ${lib.concatStringsSep " " allFlags}";

        ExecStopPost = "${pkgs.bash}/bin/bash -c '${cfg.package}/bin/k3s-killall.sh || true'";

        # Resource limits
        LimitNOFILE = "1048576";
        LimitNPROC = "infinity";
        LimitCORE = "infinity";
        TasksMax = "infinity";
        Delegate = "yes";
      };

      environment = {
        K3S_NODE_NAME = config.networking.hostName;
        K3S_KUBECONFIG_OUTPUT = "/etc/rancher/k3s/k3s.yaml";
      };

      preStart = ''
        # Create manifests directory
        mkdir -p ${cfg.dataDir}/server/manifests

        # Write custom manifests
        ${lib.concatStringsSep "\n" (
          lib.mapAttrsToList (name: content: ''
            cat > ${cfg.dataDir}/server/manifests/${name}.yaml << 'EOF'
            ${content}
            EOF
          '') cfg.manifests
        )}
      '';

      postStart = lib.mkIf (cfg.role == "server") ''
        # Wait for k3s to be ready
        timeout=60
        while [ $timeout -gt 0 ]; do
          if ${cfg.package}/bin/k3s kubectl get nodes &>/dev/null; then
            echo "k3s is ready"
            break
          fi
          echo "Waiting for k3s to be ready..."
          sleep 2
          timeout=$((timeout - 2))
        done

        # Copy kubeconfig for easier access
        if [ -f /etc/rancher/k3s/k3s.yaml ]; then
          mkdir -p /root/.kube
          cp /etc/rancher/k3s/k3s.yaml /root/.kube/config
          chmod 600 /root/.kube/config
        fi
      '';
    };

    # Environment variables
    environment.variables = lib.mkIf (cfg.role == "server") {
      KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";
    };

    # Shell aliases for convenience
    environment.shellAliases = {
      k = "kubectl";
      kgp = "kubectl get pods";
      kgs = "kubectl get services";
      kgn = "kubectl get nodes";
      k3s-logs = "journalctl -u k3s -f";
      k3s-status = "systemctl status k3s";
    };
  };
}
