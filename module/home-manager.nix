{ pkgs, ... }:

# TODO do I need this?
/*
let
files = if system == "aarch64-darwin" then {
		".yabairc".source = ../config/yabai/yabairc;
	}
else
	{};
in
*/
{
# add home-manager user settings here
# generic: fzf, tree, kitty
# derivation - like a docker image, actual build of a nix build command

# commands for building / check
# darwin-rebuild check --flake ".#aarch64"
# darwin-rebuild build --flake ".#aarch64"
	home.packages = with pkgs; [git neovim ocaml go odin gcc fzf];
	home.stateVersion = "23.11";
	home.file = {
		".yabairc".source = ../config/yabai/yabairc;
	};


	programs = {
		bash = {
			enable = true;
			bashrcExtra  = builtins.readFile ../config/bash/bashrc;
			profileExtra = builtins.readFile ../config/bash/bash_profile;
		};
		kitty = {
			enable = true; 
			extraConfig  = builtins.readFile ../config/kitty/kitty.conf;
		};
		fzf ={
			enable = true;
			enableBashIntegration = true;
		};
		gh ={
			enable = true;
		};
	};
}
