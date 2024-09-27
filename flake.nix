{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nixvim.url = "github:bauers-lab-jared/nixvim";
    roclang.url = "github:roc-lang/roc";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  }: let
    out = system: let
      pkgs = nixpkgs.legacyPackages.${system};
      nixvimPkgs = self.inputs.nixvim.inputs.nixpkgs.legacyPackages.${system};
      appliedOverlay = self.overlays.default pkgs pkgs;
      rocShell = out.roclang.devShell.${system};
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
        default = final.callPackage ./default.nix {};
      };
    };
}
