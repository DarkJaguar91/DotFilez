{
  config,
  lib,
  usr,
  configPath,
  ...
}:
with lib;
let
  cfg = config.dj.wallpapers;
in
{
  options.dj.wallpapers = {
    enable = mkEnableOption "Wallpapers symbolic link";
  };

  config = mkIf cfg.enable {
    environment.etc."tmpfiles.d/home-${usr.login}-wallpapers.conf".text = ''
      L+    /home/${usr.login}/Pictures/Wallpapers                   -    ${usr.login}    -     -           ${configPath}/Wallpapers
    '';
  };
}
