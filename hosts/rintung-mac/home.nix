{
  pkgs,
  userConfig,
  home-manager,
  ...
} @ attrs: 
let
  zshCustomDir = "${userConfig.homeDir}/.config/ohmyzsh/custom";

  zsh-module = import ../../modules/programs/zsh attrs;
in
{
  
  programs.home-manager.enable = true;
  home.stateVersion = "25.05";

  home = {
    username = "${userConfig.name}";
    homeDirectory = "${userConfig.homeDir}";
  };

  home.packages = with pkgs; [
    zsh
    oh-my-zsh
    vim
    curl
    jq
    wget
    kubectl
    docker
    vscode
    bat
  ];

  # import programs 
  imports = [
    zsh-module
  ];
}