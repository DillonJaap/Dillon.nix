{ pkgs, config, ... }:

let 
symLink = config.lib.file.mkOutOfStoreSymlink;
in
{
# add home-manager user settings here
# generic: fzf, tree, kitty
# derivation - like a docker image, actual build of a nix build command

# commands for building / check
# darwin-rebuild check --flake ".#aarch64"
# darwin-rebuild build --flake ".#aarch64"
# darwin-rebuild switch --flake ".#aarch64"
	home.packages = with pkgs; [git ocaml go odin gcc fzf];
	home.stateVersion = "23.11";

	xdg.configFile = {
		yabairc = {
			source = ../config/yabai/yabairc;
			target = "../.yabairc";
		};
		nvim = {
			source = symLink ../config/nvim;
			recursive = true;
		};
		scripts = {
			source = symLink ../config/scripts;
			target = "../.scripts/";
			recursive = true;
		};
	};

	programs = {
		bash = {
			enable = true;
			bashrcExtra  = builtins.readFile ../config/bash/bashrc;
			profileExtra = builtins.readFile ../config/bash/bash_profile;
		};
		kitty = {
			enable = true; 
			shellIntegration.enableBashIntegration = true;
			extraConfig = builtins.readFile ../config/kitty/kitty.conf;
		};
		fzf = {
			enable = true;
			enableBashIntegration = true;
		};
		gh = {
			settings.git_protocol = "https";
			settings.editor = "nvim";
			settings.aliases = {co = "pr checkout";  pv = "pr view";};
			enable = true;
		};
		neovim = {
			enable = true;
			defaultEditor = true;
		};
	};

}
