{ inputs, ... }:

# Every .nix file under ./modules is a flake-parts module. Each one publishes
# the pieces of its feature under `flake.modules.nixos` and/or
# `flake.modules.homeManager`, and the host modules pick which features they
# run. There is no central import list. Paths under a `/_` directory are not
# imported, so that is where shared helpers go.
#
# This file pulls in the flake-parts module that declares `flake.modules`.
{
  imports = [ inputs.flake-parts.flakeModules.modules ];
}
