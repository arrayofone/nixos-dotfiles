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

    users = {
      db = {
        createHome = true;
        description = "db";
        home = "/Users/db";
        isHidden = false;
        name = "db";
        openssh.authorizedKeys.keyFiles = [ ];
        openssh.authorizedKeys.keys = [ ];
        uid = 501;
      };
    };
  };
}
