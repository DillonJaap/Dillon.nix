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
	imports = [
		./home-manager-shared.nix
	];
	home.stateVersion = "23.11";

	xdg.configFile = {
		yabairc = {
			source = ../config/yabai/yabairc;
			target = "../.yabairc";
		};

	};

}
