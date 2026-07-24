{ lib, config, namespace, pkgs, ... }:
let
  cfg = config.${namespace}.monitoring;
in
{
  config = lib.mkIf cfg.server.enable { };
}
