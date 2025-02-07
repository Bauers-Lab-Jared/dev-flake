{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nixvim.url = "github:bauers-lab-jared/nixvim";
    odin-libs.url = "github:bauers-lab-jared/odin-libs";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  }: let
    odin-libs = let
      inherit (self.inputs.odin-libs) libs;
    in
      libs
      // {
        getLibsByName = libNames: map (libName: libs.${libName}) libNames;
        mkBuildArgs = libNames:
          builtins.concatStringsSep " \\\n" (
            map (libName: "-collection:${libName}='${libs.${libName}}'") libNames
          );
      };
    out = system: let
      pkgs = nixpkgs.legacyPackages.${system};
      nixvimPkgs = self.inputs.nixvim.inputs.nixpkgs.legacyPackages.${system};
      appliedOverlay = self.overlays.default pkgs pkgs;
    in {
      packages = {
        inherit (appliedOverlay) default;
        inherit odin-libs;
      };
      devShells.default = pkgs.mkShell {
        inherit (appliedOverlay.default) nativeBuildInputs buildInputs;
        LD_LIBRARY_PATH = "$LD_LIBRARY_PATH:${
          pkgs.lib.makeLibraryPath appliedOverlay.default.buildInputs
        }";

        packages = [
          (self.inputs.nixvim.lib.mkNixvim {
            pkgs = nixvimPkgs;
            addons = [
              #"proj-html" use this for web projects
              "proj-odin"
              "proj-nix"
            ];
          })
        ];
      };
    };
  in
    flake-utils.lib.eachDefaultSystem out
    // {
      overlays.default = final: prev: {
        default = final.callPackage ./default.nix {inherit odin-libs;};
      };
    };
}
