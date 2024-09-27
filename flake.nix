{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixvim.url = "github:bauers-lab-jared/nixvim";
    roc.url = "github:roc-lang/roc";
  };

  outputs = {
    self,
    roc,
    flake-utils,
    ...
  }: let
    out = system: let
      pkgs =
        import roc.inputs.nixpkgs {
          inherit system;
          config.allowUnfree = true;
        }
        // {rocpkgs = roc.packages.${system};};
      nixvimPkgs = self.inputs.nixvim.inputs.nixpkgs.legacyPackages.${system};
      appliedOverlay = self.overlays.default pkgs pkgs;
      rocShell = roc.devShell.${system};
    in {
      packages.default = appliedOverlay.default;
      devShells.default = pkgs.mkShell {
        inputsFrom = [rocShell];
        inherit (appliedOverlay.default) nativeBuildInputs buildInputs;

        inherit
          (rocShell)
          NIX_GLIBC_PATH # env vars
          LD_LIBRARY_PATH
          NIXPKGS_ALLOW_UNFREE
          shellHook # to set the LLVM_SYS_<VERSION>_PREFIX
          ;

        packages = [
          (self.inputs.nixvim.lib.mkNixvim {
            pkgs = nixvimPkgs;
            # Add nixmodules below
            addons = [
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
        default = final.callPackage ./default.nix {inherit (prev) rocpkgs;};
      };
    };
}
