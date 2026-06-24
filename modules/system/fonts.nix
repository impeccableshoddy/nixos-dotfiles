{
  pkgs,
  username,
  ...
}: {
  fonts.packages = with pkgs; [
    work-sans
    eb-garamond
    nerd-fonts.fira-code
    nerd-fonts.departure-mono
    nerd-fonts.commit-mono
  ];

  home-manager.users.${username}.home.pointerCursor = {
    name = "Bibata-Modern-Ice";
    package = pkgs.bibata-cursors;
    size = 24;
  };
}
