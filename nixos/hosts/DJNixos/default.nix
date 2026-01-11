{
  imports = [
    ./hardware.nix
  ];

  # DarkJaguar disk
  fileSystems."/DarkJaguar" = { 
    device = "/dev/disk/by-uuid/cbef05c2-50f2-4bfe-9b0a-346cfce51695";
    fsType = "btrfs";
  };
}
