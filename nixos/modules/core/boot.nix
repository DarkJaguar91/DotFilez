{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.dj.kernel;
in
{
  options.dj.kernel = {
    package = mkOption {
      type = types.attrs;
      default = pkgs.linuxPackages_latest;
      description = "The kernel package to use";
    };
  };

  config = {
    boot = {
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };
      kernelPackages = cfg.package;
    };
  };
}
