{
  config,
  lib,
  pkgs,
  usr,
  configPath,
  ...
}:
with lib;
let
  cfg = config.dj.niri;
in
{
  options.dj.niri = {
    enable = mkEnableOption "Niri desktop environment";
  };

  config = mkIf cfg.enable {
    dj.noctalia.enable = mkForce true;
    dj.swayidle.enable = mkForce true;

    services = {
      xserver.enable = true;
      displayManager.gdm.enable = true;
    };

    programs = {
      niri.enable = true;
    };

    environment.systemPackages = with pkgs; [
      xwayland-satellite

      alacritty
      foot

      # GSettings stuff
      glib
      gsettings-desktop-schemas
    ];

    environment.etc."tmpfiles.d/home-${usr.login}-niri.conf".text = ''
      L+    /home/${usr.login}/.config/niri                   -    ${usr.login}    users     -           ${configPath}/niri
    '';
  };
}
