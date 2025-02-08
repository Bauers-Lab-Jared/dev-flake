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
      inherit (nixpkgs.lib) optionals;
      extra = rec {
        names = import ./odinLibs.nix;
        pkgs = map (libName: libs.${libName}) names;
        buildArgs = builtins.concatStringsSep " \\\n" (
          map (libName: "-collection:${libName}='${libs.${libName}}'") names
        );
        odinCMD = type: let
          args =
            [
              "-use-separate-modules"
              "-define:RAYLIB_SYSTEM=true"
              "${buildArgs}"
            ]
            ++ (
              optionals (type == "build") [
                "-out:$out/bin/$pname"
                "-warnings-as-errors"
                "-build-mode:exe"
              ]
            )
            ++ (
              optionals (type == "test") [
                "-out:debug/main"
                "-o:none"
                "-all-packages"
              ]
            )
            ++ (
              optionals (type == "debug") [
                "-out:debug/main"
                "-build-mode:exe"
                "-o:none"
                "-debug"
              ]
            );
        in ''
          odin ${
            if type == "test"
            then "test"
            else "build"
          } $src \
          ${builtins.concatStringsSep " \\\n" args}
        '';
      };
    in
      libs // extra;
    out = system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          (
            final: prev: {
              # TODO: Wait for https://github.com/odin-lang/Odin/pull/4619 to be merged
              odin = prev.odin.overrideAttrs {
                patches = [
                  ./odin.patch
                ];
              };

              # TODO: Wait for https://github.com/NixOS/nixpkgs/pull/357729 to be merged
              raylib = final.callPackage ./raylib.nix {};
            }
          )
        ];
      };
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

        TEST_CMD = odin-libs.odinCMD "test";
        DEBUG_CMD = odin-libs.odinCMD "debug";

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
