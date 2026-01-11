{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.dj.gnome;
in
{
  options.dj.gnome = {
    enable = mkEnableOption "Gnome desktop environment";
  };

  config = mkIf cfg.enable {
    services = {
      xserver.enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };
  };
}
