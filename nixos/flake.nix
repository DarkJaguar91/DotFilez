{
  description = "NixOS configuration with two or more channels";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, nixpkgs-unstable, ... }@inputs:
    let
      system = "x86_64-linux";
      usr = {
        name = "Brandon Talbot";
        login = "brandon";
      };
      configPath = "/home/brandon/DJDotz";
    in
    {
      nixosConfigurations = {
        AsusZ13 = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs;
            inherit usr;
            inherit configPath;
          };
          modules = [
            ./hosts/AsusZ13
            ./modules
          ];
        };
        DJNixos = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs;
            inherit usr;
            inherit configPath;
          };
          modules = [
            ./hosts/DJNixos
            ./modules
          ];
        };
      };
    };
}
