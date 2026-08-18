def "parse vars" [] {
  $in | from csv --noheaders --no-infer | rename 'op' 'name' 'value'
}

def --env "update-env" [] {
  for $var in $in {
    if $var.op == "set" {
      if ($var.name =~ '(?i)^path$') {
        $env.PATH = ($var.value | split row (char esep))
      } else {
        load-env {($var.name): $var.value}
      }
    } else if $var.op == "hide" and $var.name in $env {
      hide-env $var.name
    }
  }
}
export-env {
  
  'set,PATH,/nix/var/nix/profiles/default/bin:/Users/DJaap/.nix-profile/bin:/opt/homebrew/bin:/Users/DJaap/.local/share/nvim/mason/bin:/Users/DJaap/.opam/bonsai-practice-5.2.1/bin:/nix/var/nix/profiles/default/bin:/Users/DJaap/.nix-profile/bin:/opt/homebrew/bin:/Users/DJaap/.nix-profile/bin:/nix/var/nix/profiles/default/bin:/Applications/kitty.app/Contents/MacOS:/usr/bin:/bin:/usr/sbin:/sbin:/Users/DJaap/.config/herd-lite/bin:/Users/DJaap/Library/Application Support/JetBrains/Toolbox/scripts:/run/current-system/sw/bin:/Users/DJaap/go/bin:/Users/DJaap/bin:/Users/DJaap/.scripts:/Users/DJaap/.local/bin:/Users/DJaap/.opam/default/bin:/Users/DJaap/Library/Android/sdk/cmdline-tools/latest/bin:/Users/DJaap/Library/Android/sdk/platform-tools:/Users/DJaap/Library/Android/sdk/emulator:/Users/DJaap/development/flutter/bin:/opt/homebrew/bin/:/usr/local/bin:/Users/DJaap/.local/bin/:/Users/DJaap/.opam/default/bin/:/nix/store/vq3n2p72v1gbi9vvckksinrmvr30673x-curl-8.19.0-bin/bin:/nix/store/z54v9rgq7ijlq8zjrl9cvqw73cdsw8ad-getconf-system_cmds-1026.140.2/bin:/nix/store/hs1xz135wmqql58x74kkz8z55r9skfby-unzip-6.0/bin:/nix/store/p5rx4ipva32mmz9x4l12mqh4rw5r8bzk-neovim-ruby-env/bin:/Users/DJaap/.config/herd-lite/bin:/Users/DJaap/Library/Application Support/JetBrains/Toolbox/scripts:/run/current-system/sw/bin:/Users/DJaap/go/bin:/Users/DJaap/bin:/Users/DJaap/.scripts:/Users/DJaap/.local/bin:/Users/DJaap/.opam/default/bin:/Users/DJaap/Library/Android/sdk/cmdline-tools/latest/bin:/Users/DJaap/Library/Android/sdk/platform-tools:/Users/DJaap/Library/Android/sdk/emulator:/Users/DJaap/development/flutter/bin
hide,MISE_SHELL,
hide,__MISE_DIFF,
hide,__MISE_DIFF,' | parse vars | update-env
  $env.MISE_SHELL = "nu"
  let mise_hook = {
    condition: { "MISE_SHELL" in $env }
    code: { mise_hook }
  }
  add-hook hooks.pre_prompt $mise_hook
  add-hook hooks.env_change.PWD $mise_hook
}

def --env add-hook [field: cell-path new_hook: any] {
  let field = $field | split cell-path | update optional true | into cell-path
  let old_config = $env.config? | default {}
  let old_hooks = $old_config | get $field | default []
  $env.config = ($old_config | upsert $field ($old_hooks ++ [$new_hook]))
}

export def --env --wrapped main [command?: string, --help, ...rest: string] {
  let commands = ["deactivate", "shell", "sh"]

  if ($command == null) {
    ^"/Users/DJaap/.local/bin/mise"
  } else if ($command == "activate") {
    $env.MISE_SHELL = "nu"
  } else if ($command in $commands) {
    ^"/Users/DJaap/.local/bin/mise" $command ...$rest
    | parse vars
    | update-env
  } else {
    ^"/Users/DJaap/.local/bin/mise" $command ...$rest
  }
}

def --env mise_hook [] {
  ^"/Users/DJaap/.local/bin/mise" hook-env -s nu
    | parse vars
    | update-env
}

