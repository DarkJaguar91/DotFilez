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

     brave
     prusa-slicer
     freecad
     blender
     vesktop
     spotify

     killall
     ripgrep

     # Arduino dev
     avrdude
     usbutils
  ];
}
