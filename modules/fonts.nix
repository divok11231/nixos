{ pkgs, ... }:
{ fonts.packages = with pkgs; [
     cantarell-fonts
     inter
     jetbrains-mono
     noto-fonts
     noto-fonts-color-emoji
     font-awesome
     roboto
     nerd-fonts.jetbrains-mono
   ];
}


