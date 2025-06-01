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
      ll = "eza --header --git --classify --long --binary --group --time-style=long-iso --links --all --all --group-directories-first --sort=name";
      tree = "eza --tree";
      dsw = "darwin-rebuild switch --flake";
      ausdir = "cd ~/Work/AUS/";
      workdir = "cd ~/Work/";
      tlppdir = "cd ~/Personal/Projects";
      nixdir = "cd ~/.config/nix";
      applyspotless = "mvn spotless:apply";
      checkspotless = "mvn spotless:check";
    };
    initContent = ''
      source ~/.p10k.zsh;
      source "$HOME/.sdkman/bin/sdkman-init.sh";
      export PATH="$HOME/.jenv/bin:$PATH";
      eval "$(jenv init -)";
    '';
    oh-my-zsh = {
      enable = true;
      custom = "/Users/tungle/.config/ohmyzsh/custom";
      plugins = [ "git" "docker" "docker-compose" "kubectl" "jenv" "aws" "zsh-autosuggestions" "you-should-use" "zsh-history-substring-search" "mvn"];
      theme = "powerlevel10k/powerlevel10k";
    };
  };
}