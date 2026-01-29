{ ... }:
{
  programs.git = {
    enable = true;
    includes = [
      {
        condition = "gitdir:~/projects/personal/";
        contents = {
          "user" = {
            email = "11287980+arrayofone@users.noreply.github.com";
            name = "arrayofone";
          };
        };
      }
      {
        condition = "gitdir:~/projects/work/";
        contents = {
          "user" = {
            email = "254569348+darrenminga@users.noreply.github.com";
            name = "darrenminga";
          };
        };
      }
    ];
    settings = {
      "commit" = {
        gpgsign = true;
      };
      "tag" = {
        gpgsign = true;
      };
    };
  };
}
