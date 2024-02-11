{ pkgs, ... }:

{
# add home-manager user settings here
# generic: fzf, tree, kitty
	home.packages = with pkgs; [ git neovim ];
	home.stateVersion = "23.11";

	programs = {
		kitty = {
			enable = true; 
		};
	};
}
