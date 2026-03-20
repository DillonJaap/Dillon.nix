{
  description = "Example kickstart Nix on macOS environment.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };


  };

  outputs = inputs@{ self, home-manager, nixpkgs, ... }:
  let
    repoPath = toString self;
    mkHome = { system, username, homeDirectory }:
      home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        extraSpecialArgs = { inherit username repoPath; };
        modules = [
          ./module/home-manager.nix
          {
            home.username = username;
            home.homeDirectory = homeDirectory;
            home.stateVersion = "25.11";
          }
        ];
      };
  in
  {
    homeConfigurations = {
      mac-aarch64 = mkHome {
        system = "aarch64-darwin";
        username = "DJaap";
        homeDirectory = "/Users/DJaap";
      };
      linux-x86_64 = mkHome {
        system = "x86_64-linux";
        username = "dillon";
        homeDirectory = "/home/dillon";
      };
    };
  };
}
