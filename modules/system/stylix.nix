{...}: {
  stylix = {
    enable = true;
    image = builtins.path {
      path = ../../wallpapers/girl.jpg;
      name = "wallpaper";
    };
    polarity = "dark";
    autoEnable = true;
    fonts = {
      monospace.name = "JetBrainsMono Nerd Font";
      sansSerif.name = "Work Sans";
      serif.name = "EB Garamond";
      sizes = {
        terminal = 13;
        applications = 13;
        desktop = 13;
        popups = 13;
      };
    };
    opacity = {
      terminal = 0.81;
      applications = 0.81;
      desktop = 0.81;
      popups = 0.9;
    };
  };
}
