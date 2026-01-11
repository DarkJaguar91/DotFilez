{
  config,
  lib,
  pkgs,
  usr,
  configPath,
  ...
}:
with lib;
let
  cfg = config.dj.nvim;
in
{
  options.dj.nvim = {
    enable = mkEnableOption "NeoVim & setup";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      neovim

      # Needed by many plugins
      git # Version control
      curl # Downloading (mason)
      unzip # Unzipper
      gnutar # Tarballs
      gzip # Gzip unzipper
      ripgrep # Better grep (telescope)
      fd # Find files

      # LSPs
      nil
      nixd
      nixfmt-rfc-style # Formatting nix files

      # Compilers
      gcc # Needed for treesitter
    ];

    environment.etc."tmpfiles.d/home-${usr.login}-nvim.conf".text = ''
      L+    /home/${usr.login}/.config/nvim                   -    ${usr.login}    -     -           ${configPath}/nvim
    '';
  };
}
