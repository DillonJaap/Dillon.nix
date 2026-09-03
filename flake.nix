{
  description = "Example kickstart Nix on macOS environment.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixgl = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
    };

  };

  outputs = inputs@{ self, home-manager, nixpkgs, nixpkgs-unstable, nixgl, ... }:
let
  mkHome = { system, username, homeDirectory, repoPath ? "${homeDirectory}/Dillon.nix" }:
    let
      isDarwin = nixpkgs.lib.strings.hasSuffix "darwin" system;
      pkgs = import nixpkgs {
        inherit system;
        overlays = if isDarwin then [] else [ nixgl.overlay ];
        config.allowUnfree = true;
      };
    in
    home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {
        inherit username repoPath;
        pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
        # Neovim nightly, built against the pinned nixpkgs.
        nvim-nightly = inputs.neovim-nightly-overlay.packages.${system}.default;
      };
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
    # Binary cache for neovim-nightly-overlay builds (trusted via
    # always-allow-substituters in the local nix config).
    nixConfig = {
      extra-substituters = [ "https://nix-community.cachix.org" ];
      extra-trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7kyed2GjQKOOv2L9CpBiYw=" ];
    };

    homeConfigurations = {
      mac-aarch64 = mkHome {
        system = "aarch64-darwin";
        username = "DJaap";
        homeDirectory = "/Users/DJaap";
      };
      mac-aarch64-personal = mkHome {
        system = "aarch64-darwin";
        username = "DJaap";
        homeDirectory = "/Users/djaap";
      };
      linux-x86_64 = mkHome {
        system = "x86_64-linux";
        username = "dillon";
        homeDirectory = "/home/dillon";
      };
    };
  };
}
