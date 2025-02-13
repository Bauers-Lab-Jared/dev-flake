{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nixvim.url = "github:bauers-lab-jared/nixvim";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  }: let
    inherit (nixpkgs) lib;
    out = system: let
      pkgs = nixpkgs.legacyPackages.${system};
      nixvimPkgs = self.inputs.nixvim.inputs.nixpkgs.legacyPackages.${system};
      appliedOverlay = self.overlays.default pkgs pkgs;
    in {
      packages = {
        inherit (appliedOverlay) default;
      };
      devShells.default = let
        inherit (appliedOverlay) update-bootloader;
      in
        pkgs.mkShell {
          inherit (appliedOverlay.default) nativeBuildInputs buildInputs;
          packages = [
            update-bootloader
            pkgs.dfu-util
            (self.inputs.nixvim.lib.mkNixvim {
              pkgs = nixvimPkgs;
              # Add nixmodules below
              addons = [
                /*
                EX:"proj-odin"
                */
                "proj-nix"
              ];
            })
          ];
        };
    };
  in
    flake-utils.lib.eachDefaultSystem out
    // {
      overlays.default = final: prev: (
        lib.packagesFromDirectoryRecursive {
          inherit (final) callPackage;
          directory = ./nix/packages;
        }
      );
    };
}
