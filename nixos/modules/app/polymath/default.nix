{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  src = builtins.fetchurl {
    url = "https://fluxkeyboard.com/updates/polymath/linux/deb/polymath_1.4.0.7_amd64.deb";
    sha256 = "1182c14ddf6bd2cdc1c66e06cbcc1b08d4b4772b972c8d63b7aada4b3acfff4d";
  };
  polymath = pkgs.stdenv.mkDerivation {
    pname = "Polymath";
    version = "1.4.0.7";

    src = src;

    nativeBuildInputs = with pkgs; [
      dpkg
      autoPatchelfHook
      glib
      libepoxy
      libgcc
      pango
      gtk3
      atk
      libusb1
      libdrm
      libgbm
      libpulseaudio
      mpv
      libayatana-appindicator
      libayatana-indicator
      libayatana-common
      libdbusmenu
      makeWrapper
    ];

    unpackPhase = ''
      dpkg-deb -x $src .
    '';

    installPhase = ''
      mkdir -p $out
      cp -r ./* $out/

      mkdir -p $out/bin
      makeWrapper $out/opt/polymath/polymath $out/bin/polymath \
        --prefix PATH : ${
          makeBinPath [
            pkgs.coreutils
            pkgs.gnugrep
          ]
        }

      mkdir -p $out/share/applications
      cp usr/share/applications/*.desktop $out/share/applications/
      substituteInPlace $out/share/applications/polymath.desktop \
        --replace /opt/polymath/polymath $out/bin/polymath \
        --replace /usr/share/pixmaps/polymath.png $out/usr/shar/pixmaps/polymath.png
    '';

    meta = {
      description = "Flux keyboard software";
      platforms = pkgs.lib.platforms.linux;
    };
  };
  cfg = config.dj.polymath;
in
{
  options.dj.polymath = {
    enable = mkEnableOption "Flux Keyboard Polymath";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      polymath
    ];
  };
}
