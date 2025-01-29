{ pkgs, ... }:
{
  fellowship.home.dev.enable = true;

  programs.zsh.envExtra = ''
    export JAVA_HOME="$(/usr/libexec/java_home -v 21)"
    export GCP_ACCOUNT_EMAIL=darren@digits.com
    export DIGITS_REPO_PATH=$HOME/digits
  '';

  home = {
    packages = with pkgs; [
      google-cloud-sdk
      claude-code
    ];
    stateVersion = "24.05";
  };
}
