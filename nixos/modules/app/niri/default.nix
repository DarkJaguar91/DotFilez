{
  pkgs,
  inputs,
  usr,
  configPath,
  ...
}:
{
  # Todo - Display Manager SDDM or GDM??
  programs = {
    niri.enable = true;
  };

  environment.systemPackages = with pkgs; [
    xwayland-satellite

    alacritty
    foot
  ];

  environment.etc."tmpfiles.d/home-${usr.login}-niri.conf".text = ''
    L+    /home/${usr.login}/.config/niri                   -    ${usr.login}    -     -           ${configPath}/niri
  '';
}
