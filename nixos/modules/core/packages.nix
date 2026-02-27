{
  pkgs,
  ...
}:
{
  nixpkgs.config.allowUnfree = true;

  programs = {
    fish.enable = true;
    appimage = {
      enable = true;
      binfmt = true;
    };
  };

  environment.systemPackages = with pkgs; [
    # App Image support
    xorg.libxcb
    xorg.libxcb.dev
    xorg.xcbutilwm
    xorg.xcbutilimage
    xorg.xcbutilkeysyms
    xorg.xcbutilrenderutil
    xcb-util-cursor
    kdePackages.qtwayland

    fishPlugins.tide
    wget
    git
    neovim
    p7zip
    xorriso

    brave
    prusa-slicer
    orca-slicer
    freecad
    blender
    vesktop
    spotify

    killall
    ripgrep

    # CLI Screenshot
    grim # screenshot tool
    slurp # Lightweight clipboard image editor
    wf-recorder # CLI Screen recorder
    swappy

    # Arduino dev
    avrdude
    usbutils

    dpkg
  ];
}
