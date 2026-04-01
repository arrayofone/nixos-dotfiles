# @gitian:security Git identity splitting — uses `gitdir:` conditional includes
# to switch between personal and work identities based on the repository path.
# Commits under `~/projects/personal/` use `arrayofone`; `~/projects/work/` uses `darrenminga`.
# GPG signing is enforced globally for both commits and tags.
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
