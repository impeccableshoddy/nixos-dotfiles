{
  pkgs,
  username,
  ...
}: {
  fonts.packages = with pkgs; [
    work-sans
    eb-garamond
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
  ];

  home-manager.users.${username}.home.pointerCursor = {
    name = "Bibata-Modern-Ice";
    package = pkgs.bibata-cursors;
    size = 24;
  };
}
