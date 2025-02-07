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
stdenv.mkDerivation rec {
  pname = "projectName";
  version = "0.1";

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
    ++ (odin-libs.getLibsByName odinLibNames);

  odinLibNames = [
    "waffle"
  ];
  src = ./src/main;

  # Inputs to be available at runtime
  buildInputs = [
    libX11
    libGL
    raylib
  ];

  buildPhase = ''
    runHook preBuild

    mkdir -p $out/bin

    odin build $src -out:$out/bin/$pname \
    ${odin-libs.mkBuildArgs odinLibNames} \
    -build-mode:exe \
    -vet \
    -disallow-do \
    -warnings-as-errors \
    -use-separate-modules \
    -define:RAYLIB_SYSTEM=true

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Resources
    cp -r $src/resources/ $out

    runHook postInstall
  '';
}
