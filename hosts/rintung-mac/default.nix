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
    home = "${userConfig.homeDir}";
  };
      
  # system settings 
  system = {
    activationScripts.postUserActivation.text = ''
      # Following line should allow us to avoid a logout/login cycle
      /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    '';
    defaults = {
      NSGlobalDomain = {
        "com.apple.mouse.tapBehavior" = 1;
        "com.apple.trackpad.enableSecondaryClick" = true;
        "com.apple.swipescrolldirection" = true;
        AppleShowScrollBars = "WhenScrolling";
        AppleInterfaceStyle = "Dark";
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        NSAutomaticWindowAnimationsEnabled = false;
        NSDocumentSaveNewDocumentsToCloud = false;
        NSNavPanelExpandedStateForSaveMode = true;
        PMPrintingExpandedStateForPrint = true;
      };
      # MacOS Dock
      dock = {
        autohide = true;
        launchanim = false;
        magnification = true;
        orientation = "bottom";
        tilesize = 32;
        show-recents = false;
        show-process-indicators = true;
        minimize-to-application = true;
        showhidden = true;
      };

      # Screenshot
      screencapture = {
        location = "/Users/${userConfig.name}/Downloads/screenshots-temp";
        type = "png";
        disable-shadow = true;
      };

      menuExtraClock = {
        ShowDate = 1;
      };
    };
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
