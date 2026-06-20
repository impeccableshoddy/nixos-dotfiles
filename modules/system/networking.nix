{
  config,
  pkgs,
  ...
}: {
  time.timeZone = "Asia/Kolkata";

  networking = {
    useDHCP = false;
    nameservers = ["1.1.1.1" "1.0.0.1"];

    networkmanager = {
      enable = true;
      wifi = {
        backend = "iwd";
        powersave = false;
      };
      # NO dns setting = default. NM writes resolv.conf directly using nameservers above.
    };
  };

  networking.wireless.iwd = {
    enable = true;
    settings = {
      Network = {
        EnableIPv6 = true;
      };
      Settings = {
        AutoConnect = true;
      };
    };
  };

  services.resolved.enable = false;

  networking.firewall = {
    enable = true;
    allowPing = true;
  };

  services.timesyncd = {
    enable = true;
    servers = ["time.cloudflare.com" "time.google.com"];
  };
}
