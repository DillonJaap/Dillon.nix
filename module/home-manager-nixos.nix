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
		awesome = {
			source = symLink ../config/awesome;
			recursive = true;
		};
		xinitrc = {
			source = symLink ../config/xinitrc;
			recursive = true;
			target = "../.xinitrc";
		};
	};

	xsession = {
		enable = true;
		windowManager.awesome = {
			enable = true;
		};
	};
}
