{ lib, config, pkgs, namespace, ... }:
let
  cfg = config.${namespace}.obsidian;

  vaultId = lib.substring 0 16 (builtins.hashString "sha256" cfg.defaultVault);

  configDir =
    if pkgs.stdenv.isDarwin
    then "${config.home.homeDirectory}/Library/Application Support/obsidian"
    else "${config.xdg.configHome}/obsidian";

  seedJson = builtins.toJSON {
    vaults.${vaultId} = {
      path = cfg.defaultVault;
      ts = 0;
      open = true;
    };
  };

  seedFile = pkgs.writeText "obsidian-vault-seed.json" seedJson;
in
{
  options.${namespace}.obsidian = {
    enable = lib.mkEnableOption "enable obsidian";

    defaultVault = lib.mkOption {
      type = lib.types.str;
      default = "${config.home.homeDirectory}/Documents/A01";
      description = "Path to the default Obsidian vault. Seeded into the Obsidian app's vault registry on first activation.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      obsidian
    ];

    home.activation.obsidianVaultSeed =
      config.lib.dag.entryAfter [ "writeBoundary" ] ''
        CONFIG_DIR=${lib.escapeShellArg configDir}
        REGISTRY="$CONFIG_DIR/obsidian.json"

        if [ ! -e "$REGISTRY" ]; then
          $DRY_RUN_CMD mkdir -p "$CONFIG_DIR"
          $DRY_RUN_CMD install -m 0644 ${seedFile} "$REGISTRY"
        fi
      '';
  };
}
