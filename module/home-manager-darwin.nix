{ pkgs, config, ... }:

let 
	symLink = config.lib.file.mkOutOfStoreSymlink;
in
{
# add home-manager user settings here
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
