{
  stdenv,
  odin,
  go-task,
  gdb,
  coreutils,
  #libGL, --use these for raylib
  #xorg,
  lib,
  writeShellScript,
  patchelf,
}:
stdenv.mkDerivation rec {
  pname = "projectName";
  version = "0.1";

  # Inputs to be available at build time
  # Now mostly for loading the dev environment.
  # Our custom builder is overriding most of
  # the automatic functionality of mkDerivation.
  nativeBuildInputs = [
    gdb
    go-task
    odin
  ];
  src = ./src/main;

  # Inputs to be available at runtime
  buildInputs = [
    #libGL -- use these for raylib
    #xorg.libX11
  ];

  builder = let
    libPath = lib.makeLibraryPath buildInputs;
  in
    writeShellScript "builder.sh" ''
      export PATH="${coreutils}/bin:${odin}/bin"
      mkdir -p $out/bin
      odin build $src -out:$out/bin/$pname

      mkdir -p $out/Resources
      cp -r $src/Resources/ $out

      ${patchelf}/bin/patchelf \
        --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath "${libPath}" \
        $out/bin/${pname}
    '';
}
