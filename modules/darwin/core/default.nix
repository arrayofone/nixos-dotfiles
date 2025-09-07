{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
{
  imports = [
    # ./dock.nix
    # ./fonts.nix
    ./homebrew.nix
    ./programs.nix
    ./secrets.nix
  ];

  options.${namespace}.system.name = lib.mkOption {
    description = "The system name";
    type = lib.types.str;
    default = "";
  };

  # local.dock = {
  #   enable = true;
  #   dock.entries = [
  #     { path = "/Applications/Slack.app/"; }
  #     { path = "/System/Applications/Messages.app/"; }
  #     { path = "/System/Applications/Facetime.app/"; }
  #     { path = "/Applications/Telegram.app/"; }
  #     { path = "${pkgs.alacritty}/Applications/Alacritty.app/"; }
  #     { path = "/System/Applications/Music.app/"; }
  #     { path = "/System/Applications/News.app/"; }
  #     { path = "/System/Applications/Photos.app/"; }
  #     { path = "/System/Applications/Photo Booth.app/"; }
  #     { path = "/System/Applications/TV.app/"; }
  #     { path = "${pkgs.jetbrains.phpstorm}/Applications/PhpStorm.app/"; }
  #     { path = "/Applications/TablePlus.app/"; }
  #     { path = "/Applications/Asana.app/"; }
  #     { path = "/Applications/Drafts.app/"; }
  #     { path = "/System/Applications/Home.app/"; }
  #     # {
  #     #   path = "${config.users.users.${user}.home}/.local/share/";
  #     #   section = "others";
  #     #   options = "--sort name --view grid --display folder";
  #     # }
  #     # {
  #     #   path = "${config.users.users.${user}.home}/.local/share/downloads";
  #     #   section = "others";
  #     #   options = "--sort name --view grid --display stack";
  #     # }
  #   ];
  # };
}
