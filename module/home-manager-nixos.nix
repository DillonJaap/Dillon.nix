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
		profileExtra = ''
			xrandr --newmode "3440x1440_60.00"  419.50  3440 3696 4064 4688  1440 1443 1453 1493 -hsync +vsync
			xrandr --addmode Virtual-1 3440x1440_60.00
		'';
	};
}
