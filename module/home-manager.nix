{ pkgs, pkgs-unstable, nvim-nightly, config, username, repoPath, ... }:
# Dotfiles are no longer managed here. They live as plain, editable files in
# their normal locations (~/.config, ~/.scripts, ~/.agents, nushell dir, etc.)
# and are tracked/synced by mise. Nix is kept only for installing packages.
{
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    home-manager
    # languages / package managers
    odin cargo 
    erlang elixir pkgs-unstable.gleam

    # cli tools
    eza ripgrep skate tree-sitter

    # fonts
    nerd-fonts.iosevka

    # editors
    pkgs-unstable.neovide

    # other
    jdk rebar3
  ];
}
