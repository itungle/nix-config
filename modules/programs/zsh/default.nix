{ userConfig, pkgs, ... }: 
let

  # powerlevel10k-theme = builtins.fetchFromGitHub {
  #   repo = "powerlevel10k";
  #   owner = "romkatv";
  #   rev = "v1.20.0";
  #   sha256 = "35833ea15f14b71dbcebc7e54c104d8d56ca5268";
  # };

  prependZshCustom = ''
    export ZSH_CUSTOM="${userConfig.homeDir}/.config/ohmyzsh/custom"
  '';

  # customDir = pkgs.stdenv.mkDerivation {
  #   name = "oh-my-zsh-custom-dir";
  #   phases = [ "buildPhase" ];
  #   buildPhase = ''
  #     mkdir -p ${userConfig.homeDir}/.config/ohmyzsh/custom
  #     cp ${powerlevel10k-theme} $out/themes/  
  #   '';
  # };

in {
  programs.zsh = {
    enable = true;
    history = {
      path = "${userConfig.homeDir}/.zsh_history"; # Example: Set custom path
      size = 10000; # Default or customized value
      save = 100000000; # Default or customized value
      # Other history options:
      # ignoreDups = true;
      # ignoreSpace = true;
    };
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      c = "clear";
      k8 = "kubectl";
      k8pod = "kubectl get pod";
      dcup = "docker-compose up -d";
      dcdown = "docker-compose down";
    };
    # plugins = [
    #   {
    #     name = "powerlevel10k";
    #     src = pkgs.zsh-powerlevel10k;
    #     file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
    #   }
    # ];
    # set the path to the custom folder
    # home.file.".zshrc".text = ''
    #   ${prependZshCustom}
    # '';
    initContent = ''
      source ~/.p10k.zsh
    '';
    oh-my-zsh = {
      enable = true;
      custom = "/Users/tungle/.config/ohmyzsh/custom";
      plugins = [ "git" "docker" "kubectl" "jenv" ];
      theme = "powerlevel10k/powerlevel10k";
    };
  };
}