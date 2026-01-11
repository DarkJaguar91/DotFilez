{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.dj.flatpak;
in
{
  options.dj.flatpak = {
    enable = mkEnableOption "Flatpak tooling";
  };

  config = mkIf cfg.enable {
    services = {
      flatpak.enable = true;
    };
  };
}
