{
  imports = [
    ./hardware.nix
  ];

  boot = {
    kernelModules = [
      "mt7925e"
      "kvm-amd"
    ];
    kernelParams = [
      "mem_sleep_default=deep"
      "pcie_aspm.policy=powersupersave"
    ];
  };

  services = {
    handheld-daemon = {
      enable = true;
      ui = {
        enable = true;
      };
      adjustor = {
        enable = true;
      };
      user = "brandon";
    };

    udev = {
      extraHwdb = ''
        # Fixes mic mute button
        evdev:name:*:dmi:bvn*:bvr*:bd*:svnASUS*:pn*:*
        KEYBOARD_KEY_ff31007c=f20
      '';
      extraRules = ''
        # Disable power auto-suspend for the ASUS N-KEY device, i.e. USB Keyboard.
        # Otherwise on certain kernel-versions, it will tend to take 1-2 key-presses to wake-up after the device suspends.
        ACTION=="add", SUBSYSTEM=="usb", TEST=="power/autosuspend", ATTR{idVendor}=="0b05", ATTR{idProduct}=="19b6", ATTR{power/autosuspend}="-1"
      '';
    };
  };

  #flow devices are 2 in 1 laptops
  hardware.sensor.iio.enable = true;

  # DJ Enabled
  dj = {
    flatpak.enable = true;
    gnome.enable = true;
    niri.enable = true;
  };
}
