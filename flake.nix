{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nixvim.url = "github:bauers-lab-jared/nixvim";
    gomod2nix = {
      url = "github:nix-community/gomod2nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    gomod2nix,
    ...
  }: let
    out = system: let
      pkgs = nixpkgs.legacyPackages.${system} // gomod2nix.legacyPackages.${system};
      nixvimPkgs = self.inputs.nixvim.inputs.nixpkgs.legacyPackages.${system};
      appliedOverlay = self.overlays.default pkgs pkgs;
    in {
      packages.default = appliedOverlay.default;
      devShells.default = pkgs.mkShell {
        nativeBuildInputs = [
        ];
        buildInputs = [
        ];
        packages = let
          goEnv = pkgs.mkGoEnv {pwd = ./.;};
        in [
          pkgs.go-task
          goEnv
          pkgs.gomod2nix
          pkgs.go
          pkgs.gopls
          pkgs.gotools
          pkgs.go-tools
          (self.inputs.nixvim.lib.mkNixvim {
            pkgs = nixvimPkgs;
            # Add nixmodules below
            addons = [
              /*
              EX:"proj-odin"
              */
              "proj-go"
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
        default = final.callPackage ./default.nix {inherit (final) buildGoApplication;};
      };
    };
}
