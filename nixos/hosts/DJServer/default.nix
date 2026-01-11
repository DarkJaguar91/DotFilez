{
  pkgs,
  ...
}:
{
  imports = [
    ./hardware.nix
  ];

  services.zfs.autoScrub.enable = true;
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;
  boot.zfs.extraPools = [
    "SSDJaguar"
    "DarkJaguar"
  ];

  # DJ Enabled
  dj = {
    # Graphics Drivers
    graphics.nvidia.enable = true;
    kernel.package = pkgs.linuxPackages;

    # Applications
    flatpak.enable = false;
    gnome.enable = false;
    niri.enable = false;
    nvim.enable = true;
    steam.enable = false;

    # Server Applications
    arr = {
      enable = true;
      configPath = "/SSDJaguar/config";
    };
    home-assistant = {
      enable = true;
      trustedProxies = [
        "192.168.68.251"
        "127.0.0.1"
      ];
    };
    netdata.enable = true;
    plex = {
      enable = true;
      configPath = "/SSDJaguar/config";
    };
  };
}
