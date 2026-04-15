# config.nu
#
# Installed by:
# version = "0.101.0"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# This file is loaded after env.nu and before login.nu
#
# You can open this file in your default editor using:
# config nu
#
# See `help config nu` for more options
#
# You can remove these comments if you want or leave
# them for future reference.


# $env.AWS_SECRET_ACCESS_KEY = "REDACTED"
# $env.AWS_ACCESS_KEY_ID = "REDACTED"

source "git-completions.nu"
source "gh-completions.nu" 

$env.path ++= ["/opt/homebrew/bin/" "/usr/local/bin" "~/.local/bin/" "~/.opam/default/bin/"]

$env.config = {
  show_banner: false
  buffer_editor : "nvim"
  edit_mode: "vi"
  table: {
    mode: "rounded"
  }
  history: {
    max_size: 10000
    sync_on_enter: true
  }
}


# load opam env
if (which opam | is-not-empty) {
	opam env --shell=powershell | parse "$env:{key} = '{val}'" | transpose -rd | load-env
}

def gittag [tag: string] {
    git tag -d $tag
    git push origin $":refs/tags/($tag)"
    git tag $tag
    git push
    git push origin $"refs/tags/($tag)"
}

def aws_deploy_login [aws_env = "devint"] {
	aws sso login --sso-session compassionv2
	match aws_env {
		"devint" => {
			let result = aws configure export-credentials | from json
			$env.AWS_SECRET_ACCESS_KEY = $result.AccessKeyId
			$env.AWS_ACCESS_KEY_ID = $result.AccessKeyId
		},
		"noprod" => {},
		_ => {},
	}
}

def upload_lambda [name: string, lambda_folder="./lambda", aws_profile="reactor_devint"] {
	let remote_lamba = aws lambda list-functions --query "Functions.FunctionName" --output text --profile $aws_profile
}

def trim-pwd [] {
  let home = ($env.HOME | path expand)
  let pwd = ($env.PWD | path expand)

  if $pwd == $home {
    "~"
  } else if ($pwd | str starts-with $home) {
    ($pwd | str replace $home "~")
  } else {
    $pwd
  }
}

$env.PROMPT_COMMAND = {||
  $"(ansi green)┌─[($env.USER) (trim-pwd)](ansi reset)
(ansi green)└──(ansi reset) "
}

$env.PROMPT_COMMAND_RIGHT = {|| "" }

def jqv [] {
  pbpaste | jq
}

def bp [] {
  pbpaste | base64 -d
}

def gitcc [] {
  git rev-parse HEAD | pbcopy
}

# Add standard OCaml dev-tools to dune-project if they are missing
def add-ocaml-dev-tools [] {
    let wanted = [
        "(ocaml-lsp-server :dev)"
        "(merlin :dev)"
        "(ocamlformat :dev)"
    ]

    let proj = open dune-project
    let existing = ($proj | lines | each { str trim })
    let to_add = ($wanted | where { |pkg|
        not ($existing | any { |l| $l == $pkg })
    })

    if ($to_add | is-empty) {
        print "All packages already present – nothing to add."
        return
    }

    let lines = ($proj | lines)
    let idx = (
        $lines
        | enumerate
        | where { |it| $it.item | str trim | str starts-with "(depends" }
        | get 0.index
    )


    let depends_line = ($lines | get $idx)
    let trimmed = ($depends_line | str trim)
    let new_deps = ($to_add | each { |p| $"  ($p)" } | str join "\n")

    let new_file = [
        ($lines | take $idx | str join "\n")
        "(depends"
        "  ocaml"
        $new_deps
        ")"
        ($lines | skip ($idx + 1) | str join "\n")
    ] | str join "\n"

    print "Packages added to dune-project:"
    for pkg in $to_add {
        print $"  ($pkg)"
    }
}

def --env ocaml_init [name: string] {
  dune init project $name;
  cd $name;

  # Create .ocamlformat file
    $"
profile = janestreet
margin = 80
sequence-blank-line=preserve-one
exp-grouping=preserve
if-then-else=fit-or-vertical
let-binding-spacing=sparse
" | save .ocamlformat;

  add-ocaml-dev-tools;
  dune pkg lock
  git init .

    $"
_build/
.merlin
.opam-switch/
*.install
*.dune-package
.DS_Store
" | save .gitignore;
  git add .gitignore;
  git add .;
  git commit -am "initial commit";
}
