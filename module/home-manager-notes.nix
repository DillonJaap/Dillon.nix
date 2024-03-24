{ pkgs, config, ... }:

let 
	symLink = config.lib.file.mkOutOfStoreSymlink;
in
{
# add home-manager user settings here
	home.packages = with pkgs; [gcc logseq skate nerdfonts];
	home.stateVersion = "23.11";

	xdg.configFile = {
		nvim = {
			source = ../config/nvim;
			recursive = true;
		};
		scripts = {
			source = symLink ../config/scripts;
			target = "../.scripts/";
			recursive = true;
		};
		xinitrc = {
			source = symLink ../config/xinitrc;
			recursive = true;
			target = "../.xinitrc";
		};
		awesome = {
			source = symLink ../config/awesome;
			recursive = true;
		};
	};

	programs = {
		bash = {
			enable = true;
			bashrcExtra  = builtins.readFile ../config/bash/bashrc;
			profileExtra = builtins.readFile ../config/bash/bash_profile;
		};
		git = {
			enable = true;
			userEmail = "dillonjaap@gmail.com";
			userName = "dillon";
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

	xsession = {
		enable = true;
		windowManager.awesome = {
			enable = true;
		};
	};

}
