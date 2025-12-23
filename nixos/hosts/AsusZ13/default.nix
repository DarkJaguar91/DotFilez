{
  imports = [
    ./hardware.nix
  ];

  boot.kernelModules = [ "mt7925e" ];
   
  services.handheld-daemon = {
    enable = true;
    ui = {
      enable = true;
    };
    adjustor = {
      enable = true;
    };
    user = "brandon";
  };
}
