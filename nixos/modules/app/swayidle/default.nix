{
  pkgs,
  usr,
  configPath,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    swayidle
  ];

  environment.etc."tmpfiles.d/home-${usr.login}-swayidle.conf".text = ''
    L+    /home/${usr.login}/.config/swayidle                   -    ${usr.login}    -     -           ${configPath}/swayidle
  '';
}
