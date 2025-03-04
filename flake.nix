{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      treefmt-nix,
      utils,
      ...
    }:
    utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        treefmtEval = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
        inherit (pkgs) mkShell;
      in
      rec {
        formatter = treefmtEval.config.build.wrapper;
        devShell = mkShell {
          nativeBuildInputs = with pkgs; [
            tokei
            nil
          ];
        };

        packages.lmxg-mu50 = pkgs.callPackage ./package.nix { };
        defaultPackage = packages.lmxg-mu50;
      }
    );
}
