{
  pkgs,
  inputs,
  usr,
  configPath,
  ...
}:
{
  services = {
    power-profiles-daemon.enable = true;
    upower.enable = true;
  };
  
  environment.systemPackages = with pkgs; [
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    matugen
  ];

  environment.etc."tmpfiles.d/home-${usr.login}-noctalia.conf".text = ''
    L+    /home/${usr.login}/.config/noctalia                   -    ${usr.login}    -     -           ${configPath}/noctalia
  '';
}
