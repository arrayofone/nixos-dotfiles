{ ... }:
{
  snowfallorg.users = {
    db = {
      create = true;

      home = {
        enable = true;
        config = { };
      };
    };
  };

  users = {
    knownGroups = [
      "db"
    ];
    knownUsers = [
      "db"
    ];

    groups = {
      # personal = {
      #   description = "";
      #   gid = 2337;
      #   members = [ "personal" ];
      #   name = "personal";
      # };
      # work = {
      #   description = "";
      #   gid = 2338;
      #   members = [ "work" ];
      #   name = "work";
      # };
    };

    users = {
      db = {
        createHome = true;
        description = "db";
        home = "/Users/db";
        isHidden = false;
        name = "db";
        openssh.authorizedKeys.keyFiles = [ ];
        openssh.authorizedKeys.keys = [ ];
        # shell = pkgs.zsh;
        uid = 501;
      };

      # work = {
      #   packages = [ ];
      #   createHome = true;
      #   description = "work";
      #   gid = 2338;
      #   home = "/Users/work";
      #   ignoreShellProgramCheck = false;
      #   isHidden = false;
      #   name = "work";
      #   openssh.authorizedKeys.keyFiles = [ ];
      #   openssh.authorizedKeys.keys = [ ];
      #   shell = pkgs.zsh;
      #   uid = 1338;
      # };
    };
  };
}
