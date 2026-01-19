{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  cfg = config.${namespace}.home.programs.zeditor;
  settings = builtins.fromJSON (builtins.readFile ./zed-settings.json);
in
{
  options.${namespace}.home.programs.zeditor = {
    nodePath = lib.mkOption {
      type = lib.types.str;
      default = "/run/current-system/sw/bin/node";
      description = "Path to node executable for Zed";
    };
    npmPath = lib.mkOption {
      type = lib.types.str;
      default = "/run/current-system/sw/bin/npm";
      description = "Path to npm executable for Zed";
    };
  };

  config.programs.zed-editor = {
    enable = true;
    package = pkgs.zed-editor;
    installRemoteServer = true;
    extraPackages = [ pkgs.nixd ];

    themes = { };
    userKeymaps = [ ];
    userTasks = [ ];

    extensions = settings.extensions;

    userSettings =
      let
        # Remove extensions from settings so they don't end up in settings.json
        # although Zed might ignore them, it's cleaner.
        cleanSettings = builtins.removeAttrs settings [ "extensions" ];
      in
      lib.recursiveUpdate cleanSettings {
        # Nix-specific binary overrides that use lib.getExe or config values
        node = {
          path = cfg.nodePath;
          npm_path = cfg.npmPath;
        };

        lsp = {
          jdtls.binary.path = lib.getExe pkgs.jdt-language-server;
          kotlin-lsp.binary.path = lib.getExe pkgs.${namespace}.kotlin-lsp;
          nix.binary.path = lib.getExe pkgs.nixd;
          protobuf-language-server.binary.path = lib.getExe pkgs.protols;
        };
      };
  };
}