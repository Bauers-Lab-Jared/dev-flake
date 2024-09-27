{
  stdenv,
  go-task,
  rocpkgs,
  lib,
  writeShellScript,
  patchelf,
  coreutils,
}:
stdenv.mkDerivation rec {
  pname = "proj-name";
  version = "0.1";
  src = ./src;

  # Inputs to be available at build time
  nativeBuildInputs = [
    go-task
    rocpkgs.cli
  ];

  # Inputs to be available at runtime
  buildInputs = [
  ];

  builder = let
    libPath = lib.makeLibraryPath buildInputs;
  in
    writeShellScript "builder.sh" ''
      export PATH="${coreutils}/bin:${rocpkgs.cli}/bin"
      mkdir -p $out/bin
      roc build "$src/main.roc" --output "$out/bin/$pname" --prebuilt-platform

      mkdir -p $out/Resources
      cp -r $src/Resources/ $out

      ${patchelf}/bin/patchelf \
        --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath "${libPath}" \
        $out/bin/${pname}
    '';
}
