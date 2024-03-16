#!/bin/bash

nix-shell -p git skate
mkdir -p $HOME/.ssh
skate link
skate sync
skate get "github public key"@keys > $HOME/.ssh/id_ed25519.pub
skate get "github private key"@keys > $HOME/.ssh/id_ed25519
exit
