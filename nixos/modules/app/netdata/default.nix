{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.dj.netdata;
in
{
  options.dj.netdata = {
    enable = mkEnableOption "Netdata Service";
  };

  config = mkIf cfg.enable {
    services = {
      netdata = {
        enable = true;
        group = "users";
        package = pkgs.netdata.override { withCloudUi = true; };
      };
    };
    users.groups.netdata = { };
    networking.firewall.allowedTCPPorts = [ 19999 ];
  };
}
