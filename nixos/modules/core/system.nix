{
  time.timeZone = "America/Vancouver";
  i18n.defaultLocale = "en_CA.UTF-8";
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
   
  nix.settings.experimental-features = [ "nix-command" "flakes"];
  system.stateVersion = "25.11";
}
