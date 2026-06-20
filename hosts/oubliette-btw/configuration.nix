{hostname, ...}: {
  imports = [
    ../../modules/system
  ];

  networking.hostName = hostname;
  system.stateVersion = "26.05";
}
