{
  pkgs,
  ...
}:
{
  users.users.brandon = {
    isNormalUser = true;
    description = "Brandon Talbot";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.fish;
  };

  nix.settings.allowed-users = [ "brandon" ];
}
