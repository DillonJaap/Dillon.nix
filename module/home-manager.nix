{ pkgs, config, username, repoPath, ... }:
let
  symLink = config.lib.file.mkOutOfStoreSymlink;
in
{
  home.stateVersion = "25.11";
  home.sessionVariables = {
    XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";
  };

  home.packages = with pkgs; [
    home-manager
    # languages / package managers
    go ocaml opam odin cargo gleam nushell erlang

    # cli tools
    fzf eza ripgrep skate gh

    # fonts
    nerd-fonts.iosevka

    # libs
    jdk
    rebar3
  ];

  xdg.configFile = {
    nvim = {
      source = symLink "${repoPath}/config/nvim";
    };
    scripts = {
      source = symLink "${repoPath}/config/scripts";
      target = "../.scripts/";
      recursive = true;
    };
    kitty = {
      source = symLink "${repoPath}/config/kitty";
      recursive = true;
    };
    nushell = {
      source = symLink "${repoPath}/config/nushell";
    };
  };

  programs = {
    bash = {
      enable = true;
      bashrcExtra = ''source "${repoPath}/config/bash/bashrc"'';
      profileExtra = ''source "${repoPath}/config/bash/bash_profile"'';
    };
    git = {
      settings = {
        user.email = "dillonjaap@gmail.com";
        user.name = username;
      };
      enable = true;
    };
    fzf = {
      enable = true;
      enableBashIntegration = true;
    };
    gh = {
      enable = true;
      settings = {
        git_protocol = "https";
        editor = "nvim";
        aliases = { co = "pr checkout"; pv = "pr view"; };
      };
    };
    nushell = {
      enable = true;
      # configFile.source = symLink "${repoPath}/config/nushell/config.nu";
      # envFile.source = symLink "${repoPath}/config/nushell/env.nu";
    };
    neovim = {
      enable = true;
      defaultEditor = true;
    };
  };
}
