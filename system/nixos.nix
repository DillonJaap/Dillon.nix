{
  inputs,
  username,
  password,
}: system: let
  configuration = import ../module/configuration.nix;
  hardware-configuration = import /etc/nixos/hardware-configuration.nix; # copy this locally to no longer run --impure
  home-manager = import ../module/home-manager.nix;
in
  inputs.nixpkgs.lib.nixosSystem {
    inherit system;

    # modules: allows for reusable code
    modules = [
      {
		boot.loader = {
			grub = {
				enable = true;
				device = "nodev";
			};
			efi.canTouchEfiVariables = true;
		};
#boot.loader.systemd-boot.enable = false;
        security.sudo.enable = true;
        security.sudo.wheelNeedsPassword = false;
        services.openssh.enable = true;
        services.openssh.settings.PasswordAuthentication = false;
        services.openssh.settings.PermitRootLogin = "no";
		services.qemuGuest.enable = true; #for vm
		services.xserver = {
			enable = true;
			autorun = false;
			displayManager.startx.enable = true;
			videoDrivers = [
				"nvidia"
			];
		};
		hardware.opengl.enable = true;
        users.mutableUsers = false;
        users.users."${username}" = {
          extraGroups = ["wheel"];
          home = "/home/${username}";
          isNormalUser = true;
          password = password;
        };
        system.stateVersion = "23.11";
      }
      hardware-configuration
      configuration

      inputs.home-manager.nixosModules.home-manager
      {
        # add home-manager settings here
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users."${username}" = home-manager;
      }
      # add more nix modules here
    ];
  }
