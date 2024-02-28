{
  description = "Example kickstart Nix on macOS environment.";

  inputs = {
    darwin.url = "github:lnl7/nix-darwin";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    home-manager.url = "github:nix-community/home-manager/release-23.11";

    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, darwin, home-manager, nixpkgs, ... }:
    let
      darwin-system = import ./system/darwin.nix { inherit inputs username; };
      username = "DJaap"; 
    in
    {
      darwinConfigurations = {
        aarch64 = darwin-system "aarch64-darwin";
        x86_64 = darwin-system "x86_64-darwin";
      };
    };
}
