{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.dj.qemu;
in
{
  options.dj.qemu = {
    enable = mkEnableOption "Qemu emulator";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      qemu
    ];
  };
}
