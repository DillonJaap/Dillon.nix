{ pkgs, ... }:

{
# add home-manager user settings here
# generic: fzf, tree, kitty
# derivation - like a docker image, actual build of a nix build command
	home.packages = with pkgs; [ git neovim ocaml go kitty opam];
	home.stateVersion = "23.11";

	programs = {
		kitty = {
			enable = true; 
		};
	};
}
