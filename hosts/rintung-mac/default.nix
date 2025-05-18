{ 
  self,
  pkgs, 
  outputs, 
  userConfig, 
  system ? "aarch64-darwin",
  ... }: {

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs;
    [ 
      zsh
      oh-my-zsh
      vim
      curl
      jq
      wget
      kubectl
      docker
      vscode
  ];

  # Necessary for using flakes on this system.
  # user touch id for sudo
  security.pam.services.sudo_local.touchIdAuth = true;
  
  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = system;
  # nix settings with optimize store 
  nix = {
    settings = {
      experimental-features = "nix-command flakes";
    };
    optimise = {
      automatic = true;
      interval = [
        {
          Minute = 0;
          Hour = 22;
          Weekday = 7;
        }
      ];
    };
  };
  
  # user config 
  users.users.${userConfig.name} = {
    name = "${userConfig.name}";
    home = "/Users/${userConfig.name}";
  };
      
  # system settings 
  system = {
    defaults = {
      
      # MacOS Dock
      dock = {
        autohide = true;
        launchanim = false;
        magnification = true;
        orientation = "bottom";
        tilesize = 32;
      };

      # Screenshot
      screencapture = {
        location = "/Users/${userConfig.name}/Downloads/temp";
        type = "png";
        disable-shadow = true;
      };


      trackpad = {
        TrackpadRightClick = true;
        TrackpadThreeFingerDrag = true;
        Clicking = true;
      };
    };
  };
  
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableBashCompletion = true;
    enableFastSyntaxHighlighting = true;
    # enableSyntaxHighlighting = true;
    # plugins = [
    #   {
    #     name = "powerlevel10k";
    #     src = pkgs.zsh-powerlevel10k;
    #     file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
    #   }
    # ];
    # initExtra = ''
    #   source ~/.p10k.zsh
    # '';
    # ohMyZsh = {
    #   enable = true;
    #   plugins = [ "git" "you-should-use" "zsh-syntax-highlighting"
    #   "zsh-autosuggestions" "zsh-bat" "docker" "kubectl" ];
    #   theme = "powerlevel10k";
    # };
  };
  
  fonts = {
    packages = with pkgs; [
      # icon fonts
      material-design-icons
      font-awesome
      nerd-fonts.symbols-only
      nerd-fonts.roboto-mono
      nerd-fonts.meslo-lg
      nerd-fonts.jetbrains-mono
    ];
  };

}
