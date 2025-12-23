{
  options,
  ...
}:
{
  networking = {
    networkmanager.enable = true;
    timeServers = options.networking.timeServers.default ++ [ "ntp.example.com" ]; 
  };
}
