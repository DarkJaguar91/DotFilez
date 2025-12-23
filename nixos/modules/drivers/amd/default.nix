{
  boot.initrd.kernelModules = [ "amdgpu" ];
  hardware.graphics.enable32Bit = true;

  services.xserver = {
    videoDrivers = [ "amdgpu" ];
  };
}
