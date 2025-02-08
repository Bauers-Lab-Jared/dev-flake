{
  stdenv,
  odin,
  go-task,
  gdb,
  libX11,
  libGL,
  raylib,
  odin-libs,
}:
stdenv.mkDerivation {
  pname = "projectName";
  version = "0.1";
  src = ./src/main;

  # Inputs to be available at build time
  # Now mostly for loading the dev environment.
  # Our custom builder is overriding most of
  # the automatic functionality of mkDerivation.
  nativeBuildInputs =
    [
      gdb
      go-task
      odin
    ]
    ++ odin-libs.pkgs;

  # Inputs to be available at runtime
  buildInputs = [
    libX11
    libGL
    raylib
  ];

  buildPhase = ''
    runHook preBuild

    mkdir -p $out/bin
    ${odin-libs.odinCMD "build"}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/resources
    cp -r $src/resources/ $out

    runHook postInstall
  '';
}
