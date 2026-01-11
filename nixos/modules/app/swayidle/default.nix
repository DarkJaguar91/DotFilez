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
  cfg = config.dj.swayidle;
in
{
  options.dj.swayidle = {
    enable = mkEnableOption "Swayidle lock timer";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      swayidle
    ];

    environment.etc."tmpfiles.d/home-${usr.login}-swayidle.conf".text = ''
      L+    /home/${usr.login}/.config/swayidle                   -    ${usr.login}    -     -           ${configPath}/swayidle
    '';
  };
}
