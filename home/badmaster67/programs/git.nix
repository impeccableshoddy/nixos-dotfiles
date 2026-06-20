{username, ...}: {
  programs.git = {
    enable = true;
    settings = {
      user.name = username;
      user.email = "227250706+${username}@users.noreply.github.com";
    };
  };
}
