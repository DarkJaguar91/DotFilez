{
  config,
  lib,
  pkgs,
  inputs,
  usr,
  configPath,
  ...
}:
with lib;
let
  cfg = config.dj.noctalia;
in
{
  options.dj.noctalia = {
    enable = mkEnableOption "Noctalia Shell";
  };

  config = mkIf cfg.enable {
    dj.wallpapers.enable = mkForce true;

    services = {
      power-profiles-daemon.enable = true;
      upower.enable = true;
    };

    environment.systemPackages = with pkgs; [
      inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
      matugen
      nwg-look
      adw-gtk3
    ];

    environment.etc."tmpfiles.d/home-${usr.login}-noctalia.conf".text = ''
      L+    /home/${usr.login}/.config/noctalia                   -    ${usr.login}    -     -           ${configPath}/noctalia
    '';
  };
}
