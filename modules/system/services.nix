{...}: {
  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = ["*"];
      settings = {
        main = {
          capslock = "overload(control, esc)";
        };
      };
    };
  };

  services.vnstat.enable = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  hardware.acpilight.enable = true;
}
