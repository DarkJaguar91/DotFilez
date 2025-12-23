{
  usr,
  configPath,
  ...
}:
{
  environment.etc."tmpfiles.d/home-${usr.login}-wallpapers.conf".text = ''
    L+    /home/${usr.login}/Pictures/Wallpapers                   -    ${usr.login}    -     -           ${configPath}/Wallpapers
  '';
}
