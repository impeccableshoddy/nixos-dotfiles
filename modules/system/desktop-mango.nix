{
  pkgs,
  username,
  ...
}: {
  services.getty.autologinUser = username;
  environment.loginShellInit = ''
    [ "$(tty)" = /dev/tty1 ] && exec mango
  '';

  programs.mango.enable = true;

  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      thunar-archive-plugin
      thunar-volman
    ];
  };

  programs.xfconf.enable = true;
  services.udisks2.enable = true;
  services.gvfs.enable = true;

  environment.systemPackages = with pkgs; [
    git
    wget
    curl
    android-tools
    jmtpfs
    libmtp
  ];
}
