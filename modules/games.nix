{ ... }:

# ordovician plays games through gamescope; steam itself is enabled in
# host-base, which every host gets.
{
  flake.modules.nixos.games = {
    programs.gamescope.enable = true;
    programs.steam.gamescopeSession.enable = true;
  };
}
