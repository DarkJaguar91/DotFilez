{
  pkgs,
  ...
}:
{
  programs = {
    gamescope = {
      enable = true;
      capSysNice = true;
    };
    steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      gamescopeSession.enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    protonplus
    mangohud
    mangojuice

    # Extra UDEV rules
    steam-devices-udev-rules
  ];
}
