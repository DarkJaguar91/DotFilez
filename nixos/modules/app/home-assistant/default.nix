{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.dj.home-assistant;
in
{
  options.dj.home-assistant = {
    enable = mkEnableOption "Home Assistant";
    trustedProxies = mkOption {
      type = types.attrs;
      default = [ "127.0.0.1" ];
      description = "Trusted Proxies for Home Assistant";
    };
  };

  config = mkIf cfg.enable {
    services = {
      home-assistant = {
        enable = true;
        openFirewall = true;
        extraComponents = [
          "analytics"
          "default_config"
          "wled"
          "radio_browser"
          "met"
          "google_translate"
          "isal"
        ];

        config = {
          default_config = { };

          http = {
            server_host = "0.0.0.0";
            trusted_proxies = cfg.trustedProxies;
            use_x_forwarded_for = true;
          };
        };
      };
    };
  };
}
