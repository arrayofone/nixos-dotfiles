{ ... }:
{
  snowfallorg.users = {
    darrenbangsund = {
      create = false;

      home = {
        enable = true;
        config = { };
      };
    };
    db = {
      create = false;

      home = {
        enable = false;
        config = { };
      };
    };
  };

  users = {
    knownGroups = [ ];
    knownUsers = [
      "darrenbangsund"
    ];

    users = {
      darrenbangsund = {
        createHome = false;
        description = "darrenbangsund";
        home = "/Users/darrenbangsund";
        isHidden = false;
        name = "darrenbangsund";
        openssh.authorizedKeys.keyFiles = [ ];
        openssh.authorizedKeys.keys = [ ];
        # shell = pkgs.zsh;
        uid = 502;
        gid = 20;
      };
      # db = {
      #   createHome = false;
      #   description = "db";
      #   home = "/Users/db";
      #   isHidden = false;
      #   name = "db";
      #   openssh.authorizedKeys.keyFiles = [ ];
      #   openssh.authorizedKeys.keys = [ ];
      #   # shell = pkgs.zsh;
      #   uid = 502;
      #   gid = 20;
      # };
    };
  };
}
