{...}: {
  time.timeZone = "Asia/Calcutta";
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.backend = "iwd";
  networking.networkmanager.dns = "none";
  networking.nameservers = ["1.1.1.1" "1.0.0.1" "8.8.8.8"];
}
