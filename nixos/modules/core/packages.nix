{
  pkgs,
  ...
}: 
{
  nixpkgs.config.allowUnfree = true;
  
  programs = {
    fish.enable = true;
  };

  environment.systemPackages = with pkgs; [
     fishPlugins.tide
     wget
     git
     neovim

     brave
     prusa-slicer
     freecad
     vesktop
     spotify
  ];
}
