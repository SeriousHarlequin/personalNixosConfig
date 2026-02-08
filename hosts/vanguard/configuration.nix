{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../globalModules/nixos/default.nix
    ];

  myNixos = {
    nvidia = {
      enable = true;
      hybrid.enable = false;
    };

    gaming = {
      steam.enable = true;
      steam.gamescope.enable = false;
    };

    software = {
        cli-tools.enable = true;
        libreoffice.enable = true;
        virt-manager.enable = true;
        alvr.enable = true;
    };

    autoUpdate = {
      enable = true;
      dates = "weekly";
    };

    desktopEnvironments.enableList = [ "gnome" "niri" ];
  };
  
  networking.hostName = "vanguard"; # Define your hostname.

  # Add user to virtualization group
  users.groups.libvirtd.members = ["fabian"];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  services.displayManager.gdm.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = false;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.fabian = {
    isNormalUser = true;
    description = "Fabian Schaetzschock";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Install the zsh shell
  programs.zsh.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    thunderbird
    discord
    pavucontrol
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "25.11";

}
