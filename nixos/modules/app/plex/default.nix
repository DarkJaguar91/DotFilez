{
  config,
  lib,
  usr,
  ...
}:
with lib;
let
  cfg = config.dj.plex;
in
{
  options.dj.plex = {
    enable = mkEnableOption "Plex media server";
    configPath = mkOption {
      type = types.path;
      default = "/home/${usr.login}/.config";
      description = "Path to store Plex config files";
    };
  };

  config = mkIf cfg.enable {
    services = {
      plex = {
        enable = true;
        openFirewall = true;
        dataDir = "${cfg.configPath}/plex";
        group = "users";
        user = usr.login;
      };
    };
  };
}
