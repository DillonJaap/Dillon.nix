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
		darwin-system = import ./system/darwin.nix { 
				inherit inputs;
				username = "DJaap"; 
			};
		nixos-system = import ./system/nixos.nix {
			inherit inputs;
			username = "dillon"; 
			password = "temppass"; 
		};
		nixos-notes-system = import ./system/nixos.nix {
			inherit inputs;
			username = "dillon"; 
			password = "temppass"; 
		};
    in
    {
      darwinConfigurations = {
        aarch64 = darwin-system "aarch64-darwin";
        x86_64 = darwin-system "x86_64-darwin";
      };
      nixosConfigurations = {
        aarch64 = nixos-system "aarch64-linux";
        x86_64 = nixos-system "x86_64-linux";
        notes = nixos-notes-system "x86_64-linux";
	  };
	};
}
