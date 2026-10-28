{ ... }:

# ordovician plays games through gamescope; the steam app itself is in the
# apps feature, which every host gets.
{
  flake.modules.nixos.games = {
    programs.gamescope.enable = true;
    programs.steam.gamescopeSession.enable = true;
  };
}
