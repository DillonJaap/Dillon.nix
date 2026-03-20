{ pkgs, config, username, repoPath, ... }:
let
  symLink = config.lib.file.mkOutOfStoreSymlink;
in
{
  home.stateVersion = "25.05";
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
    "kitty/kitty.conf".text = ''
      # ======================
      # FONT SETTINGS
      # ======================

      font_family     Iosevka Nerd Font Mono
      font_size 14

      # ======================
      # CURSOR SETTINGS
      # ======================

      cursor_shape underline

      # ======================
      # WINDOW & LAYOUT
      # ======================

      enabled_layouts stack
      hide_window_decorations titlebar-only
      tab_bar_style powerline

      # ======================
      # SHELL & EDITOR
      # ======================

      shell ${config.home.homeDirectory}/.scripts/shell-launcher
      editor nvim
      allow_remote_control yes

      # ======================
      # MACOS OPTIONS
      # ======================

      macos_option_as_alt no
      map opt+cmd+s toggle_macos_secure_keyboard_entry
      map cmd+, no_op

      # ======================
      # CUSTOM SHORTCUTS
      # ======================

      map ctrl+b>1 launch --env PATH="$PATH:/usr/local/bin" --type tab ${config.home.homeDirectory}/.scripts/kitty-tab-manager "${config.home.homeDirectory}/code/gitlab.com/ciorg/bridge/am-interventions/lambda-backend"
      map ctrl+b>2 launch --env PATH="$PATH:/usr/local/bin" --type tab ${config.home.homeDirectory}/.scripts/kitty-tab-manager "~/code/gitlab.com/ciorg/bridge/am-interventions/am-intervention-api"
      map ctrl+b>3 launch --env PATH="$PATH:/usr/local/bin" --type tab ${config.home.homeDirectory}/.scripts/kitty-tab-manager "~/code/gitlab.com/ciorg/bridge/am-interventions/event-handlers"
      map ctrl+b>4 launch --env PATH="$PATH:/usr/local/bin" --type tab ${config.home.homeDirectory}/.scripts/kitty-tab-manager "~/.config"
      map ctrl+b>5 launch --env PATH="$PATH:/usr/local/bin" --type tab ${config.home.homeDirectory}/.scripts/kitty-tab-manager "~/Notes"
      map ctrl+b>6 launch --env PATH="$PATH:/usr/local/bin" --type tab ${config.home.homeDirectory}/.scripts/kitty-tab-manager "~/code/cdk-workshop"

      map ctrl+s launch --env PATH="$PATH:/usr/local/bin:/opt/homebrew/bin" --type overlay-main ${config.home.homeDirectory}/.scripts/kitty-tab-manager
      map ctrl+shift+s launch --env PATH="$PATH:/usr/local/bin:/opt/homebrew/bin" --type overlay-main ${config.home.homeDirectory}/.scripts/kitty-tab-manager "update-list"

      map cmd+. next_window
      map cmd+, previous_window
      map cmd+x close_window

      map alt+n next_tab
      map alt+tab next_tab
      map alt+p previous_tab
      map alt+shift+tab next_tab
      map alt+c new_tab
      map alt+x close_tab

      # ======================
      # COLOR SCHEME (Kanagawa Dragon)
      # ======================

      background #181616
      foreground #c5c9c5
      selection_background #2D4F67
      selection_foreground #C8C093
      url_color #72A7BC
      cursor #C8C093
      cursor_text_color background

      active_tab_background #12120f
      active_tab_foreground #C8C093
      active_tab_font_style bold
      inactive_tab_background #12120f
      inactive_tab_foreground #a6a69c
      inactive_tab_font_style normal

      color0  #0d0c0c
      color1  #c4746e
      color2  #8a9a7b
      color3  #c4b28a
      color4  #8ba4b0
      color5  #a292a3
      color6  #8ea4a2
      color7  #C8C093
      color8  #a6a69c
      color9  #E46876
      color10 #87a987
      color11 #E6C384
      color12 #7FB4CA
      color13 #938AA9
      color14 #7AA89F
      color15 #c5c9c5
      color16 #b6927b
      color17 #b98d7b
    '';
  };

  programs = {
    bash = {
      enable = true;
      bashrcExtra = ''source "${repoPath}/config/bash/bashrc"'';
      profileExtra = ''source "${repoPath}/config/bash/bash_profile"'';
    };
    git = {
      enable = true;
      userEmail = "dillonjaap@gmail.com";
      userName = username;
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
      configFile.source = symLink "${repoPath}/config/nushell/config.nu";
      envFile.source = symLink "${repoPath}/config/nushell/env.nu";
    };
    neovim = {
      enable = true;
      defaultEditor = true;
    };

  };
}
