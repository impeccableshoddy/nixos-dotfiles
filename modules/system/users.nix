{username, ...}: {
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = ["wheel" "input" "networkmanager" "video"];
  };
}
