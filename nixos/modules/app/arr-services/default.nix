{
  config,
  lib,
  usr,
  ...
}:
with lib;
let
  cfg = config.dj.arr;
in
{
  options.dj.arr = {
    enable = mkEnableOption "ARR Services; Sonarr, Radarr, Prowlarr, Overseerr & SabNZBD";
    configPath = mkOption {
      type = types.path;
      default = "/home/${usr.login}/.config";
      description = "Path to store ARR services config files";
    };
  };

  config = mkIf cfg.enable {
    services = {
      overseerr = {
        enable = true;
        openFirewall = true;
      };

      prowlarr = {
        enable = true;
        openFirewall = true;
        dataDir = "${cfg.configPath}/prowlarr";
      };

      radarr = {
        enable = true;
        openFirewall = true;
        dataDir = "${cfg.configPath}/radarr";
        group = "users";
        user = usr.login;
      };

      sabnzbd = {
        enable = true;
        openFirewall = true;
        configFile = "${cfg.configPath}/sabnzbd/sabnzbd.ini";
        group = "users";
        user = usr.login;
      };

      sonarr = {
        enable = true;
        openFirewall = true;
        dataDir = "${cfg.configPath}/sonarr";
        group = "users";
        user = usr.login;
      };
    };
  };
}
