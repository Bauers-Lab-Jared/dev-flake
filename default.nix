{
  stdenv,
  odin,
  go-task,
  gdb,
  coreutils,
  autoPatchelfHook,
  #libGL, --use these for raylib
  #xorg,
  lib,
  writeShellScript,
  patchelf,
  odin-libs,
}:
stdenv.mkDerivation rec {
  pname = "projectName";
  version = "0.1";

  # Inputs to be available at build time
  # Now mostly for loading the dev environment.
  # Our custom builder is overriding most of
  # the automatic functionality of mkDerivation.
  nativeBuildInputs =
    [
      autoPatchelfHook
      gdb
      go-task
      odin
    ]
    ++ (odin-libs.getLibsByName odinLibNames);

  odinLibNames = [
    "waffle"
  ];
  src = ./src/main;

  # Inputs to be available at runtime
  buildInputs = [
    #libGL -- use these for raylib
    #xorg.libX11
  ];

  buildPhase = ''
    runHook preBuild

    export PATH="''${PATH}:${coreutils}/bin:${odin}/bin"
    mkdir -p $out/bin
    odin build $src -out:$out/bin/$pname \
    ${odin-libs.mkBuildArgs odinLibNames}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Resources
    cp -r $src/resources/ $out

    runHook postInstall
  '';

  #  preFixup = let
  #    libPath = lib.makeLibraryPath buildInputs;
  #  in ''
  #    ${patchelf}/bin/patchelf \
  #      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
  #      --set-rpath "${libPath}" \
  #      $out/bin/${pname}
  #  '';
}
