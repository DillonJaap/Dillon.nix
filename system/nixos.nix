{
  inputs,
  username,
  password,
}: system: let
  configuration = import ../module/configuration.nix;
  hardware-configuration = import /etc/nixos/hardware-configuration.nix; # copy this locally to no longer run --impure
  home-manager = import ../module/home-manager-nixos.nix;
in
  inputs.nixpkgs.lib.nixosSystem {
    inherit system;

    # modules: allows for reusable code
    modules = [
      {
        # Bootloader.
		boot.loader = {
			grub = {
				enable = true;
				device = "nodev";
				efiSupport = true;
			};
			efi.canTouchEfiVariables = true;
		};

        #boot.loader.systemd-boot.enable = false;

        # Enable networking
        networking.networkmanager.enable = true;

        # Set your time zone.
        time.timeZone = "America/Denver";

        # Select internationalisation properties.
        i18n.defaultLocale = "en_US.UTF-8";

        i18n.extraLocaleSettings = {
          LC_ADDRESS = "en_US.UTF-8";
          LC_IDENTIFICATION = "en_US.UTF-8";
          LC_MEASUREMENT = "en_US.UTF-8";
          LC_MONETARY = "en_US.UTF-8";
          LC_NAME = "en_US.UTF-8";
          LC_NUMERIC = "en_US.UTF-8";
          LC_PAPER = "en_US.UTF-8";
          LC_TELEPHONE = "en_US.UTF-8";
          LC_TIME = "en_US.UTF-8";
        };

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
				"virtio_gpu"
			];
		};

        # Guest drivers
		services.spice-webdavd.enable = true;
		services.spice-vdagentd.enable = true;
		services.spice-autorandr.enable = true;

        # Define a user account. Don't forget to set a password with ‘passwd’.
        users.mutableUsers = false;
        users.users."${username}" = {
           extraGroups = ["wheel" "networkmanager"];
          home = "/home/${username}";
          isNormalUser = true;
          password = password;
        };


        # env variables
		environment.variables.LIBGL_ALWAYS_SOFTWARE = "1";

        # nixpkgs settings
		nixpkgs.config.allowUnfree = true;
        nixpkgs.config.permittedInsecurePackages = ["electron-25.9.0"];
        # List packages installed in system profile. To search, run:
        # $ nix search wget
        #environment.systemPackages = with pkgs; [
        #  vim # Do not forget to add an editor to edit configuration.nix! 
        #  The Nano editor is also installed by default.
        #  wget
        #];

        system.stateVersion = "23.11";

        # hardware
		hardware.opengl.enable = true;

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
