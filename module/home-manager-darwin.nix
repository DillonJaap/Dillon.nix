{ pkgs, config, ... }:

let 
	symLink = config.lib.file.mkOutOfStoreSymlink;
in
{
# add home-manager user settings here
	imports = [
		./home-manager-shared.nix
	];
	home.packages = with pkgs; [aws-sam-cli nodePackages_latest.aws-cdk awscli];
	home.stateVersion = "23.11";

	xdg.configFile = {
		yabairc = {
			source = ../config/yabai/yabairc;
			target = "../.yabairc";
		};
	};

}
