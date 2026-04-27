# env.nu
#
# Installed by:
# version = "0.101.0"
#
# Previously, environment variables were typically configured in `env.nu`.
# In general, most configuration can and should be performed in `config.nu`
# or one of the autoload directories.
#
# This file is generated for backwards compatibility for now.
# It is loaded before config.nu and login.nu
#
# See https://www.nushell.sh/book/configuration.html
#
# Also see `help config env` for more options.
#
# You can remove these comments if you want or leave
# them for future reference.


$env.path ++= [
  "/opt/homebrew/bin"
  "/Users/DJaap/Library/Python/3.9/bin"
  "/Users/DJaap/.config/herd-lite/bin"
  "/run/current-system/sw/bin"
  "~/go/bin"
  "~/bin"
  "~/.scripts"
  "~/.opam/default/bin/dune"
	"~/.opam/default/bin/"
  "~/Library/Android/sdk/cmdline-tools/latest/bin"
  "~/Library/Android/sdk/platform-tools"
  "~/Library/Android/sdk/emulator"
  "/~/.local/bin"
]

$env.ANDROID_HOME = "~/Library/Android/sdk"
$env.ANDROID_SDK_ROOT = "/home/dillon/Android/Sdk"
