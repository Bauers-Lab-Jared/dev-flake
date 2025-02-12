{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nixvim.url = "github:bauers-lab-jared/nixvim";
    nix-odin.url = "github:bauers-lab-jared/nix-odin";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  }: let
    inherit (self.inputs) nix-odin;
    out = system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [nix-odin.overlays.default];
      };
      nixvimPkgs = self.inputs.nixvim.inputs.nixpkgs.legacyPackages.${system};
      appliedOverlay = self.overlays.default pkgs pkgs;
    in {
      packages = {
        inherit (appliedOverlay) default;
      };
      odinConfig = appliedOverlay.default.cfg;
      devShells.default = pkgs.mkShell {
        inherit (appliedOverlay.default) nativeBuildInputs buildInputs;
        LD_LIBRARY_PATH = "$LD_LIBRARY_PATH:${
          pkgs.lib.makeLibraryPath appliedOverlay.default.buildInputs
        }";

        #        TEST_CMD = odinConfig.cli.test.cmd;
        #        DEBUG_CMD = odinConfig.cli.debug.cmd;

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
        default = final.callPackage (final.buildOdin (import ./config.nix)) {};
      };
    };
}
