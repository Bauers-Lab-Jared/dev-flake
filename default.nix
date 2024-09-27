{
  stdenv,
  go-task,
  rocpkgs,
}:
stdenv.mkDerivation (let
  name = "proj-name";
  src = ./src;
in {
  inherit name src;

  # Inputs to be available at build time
  nativeBuildInputs = [
    go-task
    rocpkgs.cli
  ];

  # Inputs to be available at runtime
  buildInputs = [
  ];

  buildPhase = "";
  /*
                           Example:
  ''
    odin build ${src}/main -out:${name}
  ''
  */

  installPhase = ''
    mkdir -p $out/bin
    cp ${name} $out/bin
  '';
})
