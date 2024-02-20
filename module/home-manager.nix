{ pkgs, ... }:

{
# add home-manager user settings here
# generic: fzf, tree, kitty
# derivation - like a docker image, actual build of a nix build command

# commands for building / check
# darwin-rebuild check --flake ".#aarch64"
# darwin-rebuild build --flake ".#aarch64"
	home.packages = with pkgs; [ git neovim ocaml go kitty];
	home.stateVersion = "23.11";

	programs = {

		kitty = {
			enable = true; 
			extraConfig  = builtins.readFile ../config/kitty/kitty.conf;
		};
	};
}
