{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    roc.url = "github:roc-lang/roc";
    nixvim-waffle.url = "git+ssh://gitea@git.sgtwaffle.com:2022/waffle/nixvim?ref=main";
  };

  outputs =
    {
      self,
      roc,
      flake-utils,
      ...
    }:
    let
      user = "waffle";
      out =
        system:
        let
          pkgs =
            import roc.inputs.nixpkgs {
              inherit system;
              config.allowUnfree = true;
            }
            // {
              rocpkgs = roc.packages.${system};
            };
          appliedOverlay = self.overlays.default pkgs pkgs;
          rocShell = roc.devShells.${system}.default;
        in
        {
          packages.default = appliedOverlay.default;
          devShells.default = pkgs.mkShell {
            inputsFrom = [ rocShell ];
            inherit (appliedOverlay.default) nativeBuildInputs buildInputs;

            inherit (rocShell)
              NIX_GLIBC_PATH # env vars
              LD_LIBRARY_PATH
              shellHook # to set the LLVM_SYS_<VERSION>_PREFIX
              ;

            packages = [
              (self.inputs."nixvim-${user}".nixvimWithFlags.${system} [
                "roc"
              ])
            ];
          };
        };
    in
    flake-utils.lib.eachDefaultSystem out
    // {
      overlays.default = final: prev: {
        default = final.callPackage ./default.nix { inherit (prev) rocpkgs; };
      };
    };
}
