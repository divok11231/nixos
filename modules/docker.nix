{ pkgs, ... }:

{
  virtualisation.docker.enable = true;

  users.users.kovid.extraGroups = [ "docker" ];

  environment.systemPackages = with pkgs; [
    docker
    docker-compose
  ];
}
