{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.dj.graphics.amd;
in
{
  options.dj.graphics.amd = {
    enable = mkEnableOption "AMD Graphics Drivers";
  };

  config = mkIf cfg.enable {
    boot.initrd.kernelModules = [ "amdgpu" ];
    hardware.graphics.enable32Bit = true;

    services.xserver = {
      videoDrivers = [ "amdgpu" ];
    };
  };
}
