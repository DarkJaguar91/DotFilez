{
  imports = [
    ./hardware.nix
  ];

  # DarkJaguar disk
  fileSystems."/DarkJaguar" = {
    device = "/dev/disk/by-uuid/cbef05c2-50f2-4bfe-9b0a-346cfce51695";
    fsType = "btrfs";
  };

  # DJ Enabled
  dj = {
    # Graphics Drivers
    graphics.amd.enable = true;

    # Applications
    flatpak.enable = true;
    gnome.enable = true;
    niri.enable = true;
    nvim.enable = true;
    steam.enable = true;

    # Server Applications
    arr = {
      enable = false;
      configPath = "/SSDJaguar/config";
    };
    home-assistant = {
      enable = false;
      trustedProxies = [
        "192.168.68.251"
        "127.0.0.1"
      ];
    };
    netdata.enable = false;
    plex = {
      enable = false;
      configPath = "/SSDJaguar/config";
    };
  };
}
