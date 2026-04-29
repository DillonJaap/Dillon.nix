{ pkgs, pkgs-unstable, config, username, repoPath, ... }:
let
  symLink = config.lib.file.mkOutOfStoreSymlink;
  isDarwin = pkgs.stdenv.isDarwin;
  nushellConfigDir = if isDarwin
    then "Library/Application Support/nushell"
    else ".config/nushell";
in
{
  home.stateVersion = "25.11";

  home.sessionVariables = {
    XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";
  };

  home.file = {
    # Symlink nushell config into the OS-appropriate directory.
    # macOS defaults to ~/Library/Application Support/nushell;
    # Linux uses ~/.config/nushell (via XDG).
    "${nushellConfigDir}/config.nu".source = symLink "${repoPath}/config/nushell/config.nu";
    "${nushellConfigDir}/env.nu".source = symLink "${repoPath}/config/nushell/env.nu";
    "${nushellConfigDir}/git-completions.nu".source = symLink "${repoPath}/config/nushell/git-completions.nu";
    "${nushellConfigDir}/gh-completions.nu".source = symLink "${repoPath}/config/nushell/gh-completions.nu";
    # neovide config
    "${config.home.homeDirectory}/.config/neovide/config.toml".source = symLink "${repoPath}/config/neovide/config.toml";
  };

  home.packages = with pkgs; [
    home-manager
    # languages / package managers
    go ocaml opam odin 
    # cargo 
    nushell 
    erlang elixir pkgs-unstable.gleam

    # cli tools
    fzf eza ripgrep skate gh tree-sitter

    # fonts
    nerd-fonts.iosevka

    # editors
    # pkgs-unstable.neovide

    # other
    jdk rebar3
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
      font_size 12

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
      # SOCKET
      # ======================
      allow_remote_control yes
      listen_on unix:${config.home.homeDirectory}/.kitty.sock

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

      map alt+equal increase_font_size
      map alt+minus decrease_font_size
      map alt+0 restore_font_size

      # ======================
      # COLOR SCHEME (Evergarden Spring)
      # ======================

      background #2b3438
      foreground #f8f9e8
      selection_background #4a585c
      selection_foreground #f8f9e8
      url_color #b3e3ca
      cursor #cbe3b3
      cursor_text_color background

      active_tab_background #232a2e
      active_tab_foreground #cbe3b3
      active_tab_font_style bold
      inactive_tab_background #232a2e
      inactive_tab_foreground #6f8788
      inactive_tab_font_style normal

      # black / bright black
      color0  #3e4a4f
      color8  #58686d
      # red / bright red
      color1  #f57f82
      color9  #f57f82
      # green / bright green
      color2  #cbe3b3
      color10 #dbe6af
      # yellow / bright yellow
      color3  #f5d098
      color11 #f7a182
      # blue / bright blue
      color4  #b2caed
      color12 #afd9e6
      # magenta / bright magenta
      color5  #d2bdf3
      color13 #f3c0e5
      # cyan / bright cyan
      color6  #b3e3ca
      color14 #b3e6db
      # white / bright white
      color7  #adc9bc
      color15 #f8f9e8
    '';
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

    neovim = {
      enable = true;
      defaultEditor = true;
      package = pkgs-unstable.neovim-unwrapped;
    };

  };
}
