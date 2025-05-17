{ pkgs, ... }: {

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    [ pkgs.vim
    ];

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";
  security.pam.services.sudo_local.touchIdAuth = true;


  # Enable alternative shell support in nix-darwin.
  # programs.fish.enable = true;

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
  # nix settings with optimize store 
  # nix = {
  #   settings = {
  #     experimental-features = "nix-command flakes";
  #     auto-optimise-store = true;
  #   };
  #   optimise = {
  #     automatic = true;
  #     interval = [
  #       {
  #         Minute = 0;
  #         Hour = 22;
  #         Weekday = 7;
  #       }
  #     ]
  #   };
  # };
  

  # user config 
  # users.users.${userConfig.name} = {
  #   name = ${userConfig.name};
  #   home = "/Users/${userConfig.name}";
  # };
    
  # user touch id for sudo
  
  # system settings 
  # system = {
  #   defaults = {
      
  #     # MacOS Dock
  #     dock = {
  #       autohide = true;
  #       launchanim = false;
  #       magnification = true;
  #       orientation = "bottom";
  #       tilesize = 32;
  #     };

  #     # Screenshot
  #     # screencapture = {
  #     #   location = "/Users/${userConfig.name}/Downloads/temp";
  #     #   type = "png";
  #     #   disable-shadow = true;
  #     # };


  #     trackpad = {
  #       TrackpadRightClick = true;
  #       TrackpadThreeFingerDrag = true;
  #       Clicking = true;
  #     };
  #   };
  # };
  
  # programs.zsh = {
  #   enable = true;
  #   enableCompletion = true;
  #   plugins = [
  #     {
  #       name = "powerlevel10k";
  #       src = pkgs.zsh-powerlevel10k;
  #       file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
  #     }
  #   ];
  #   initExtra = ''
  #     source ~/.p10k.zsh
  #   '';
  #   ohMyZsh = {
  #     enable = true;
  #     plugins = [ "git" "you-should-use" "zsh-syntax-highlighting"
  #     "zsh-autosuggestions" "zsh-bat" "docker" "kubectl" ];
  #     theme = "powerlevel10k";
  #   };
  # };
  
  # fonts.packages = with pkgs; [
  #   nerd-fonts.meslo-lg
  # ];

}