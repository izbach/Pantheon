
{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "aries";
  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Edmonton";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
  

  home-manager.backupFileExtension = "backup";
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."isaac" = {
    isNormalUser = true;
    description = "isaac";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  environment.systemPackages = with pkgs; [
     git
     hyprland
  #  sddm
     quickshell
     wofi
     kitty
     neovim
  ];

  programs.firefox.enable = true;
  programs.hyprland.enable = true;
  programs.neovim.defaultEditor = true;  
  # services.openssh.enable = true;

  networking.firewall.allowedTCPPorts = [ 47984 47989 48010  ];
  networking.firewall.allowedUDPPorts = [ 47998 47999 48000 48002 48010 ];
  # networking.firewall.enable = false;


  system.stateVersion = "26.05"; 

  nix.gc = {
     automatic = true;
     dates = "weekly";
     options = "--delete-older-than 30d";
  };

}
