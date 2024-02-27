{ pkgs, ... }:

{
	home.packages = with pkgs; [yabai];

	home.file = {
		".yabairc".source = ../config/yabai/yabairc;
	};

	programs = {};
}
