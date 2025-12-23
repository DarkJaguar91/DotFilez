{
  pkgs,
  ...
}:
{
  fonts = {
    packages = with pkgs; [
      font-awesome
      material-icons
      nerd-fonts.jetbrains-mono
    ];
  };
}
