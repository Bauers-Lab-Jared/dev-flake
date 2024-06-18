{
  stdenv,
  odin,
  clang,
  llvm_17,
  go-task,
  gdb,
  # Args for this func will be sourced by nixpkgs automatically
}:
stdenv.mkDerivation (let
  name = "proj-name";
  src = ./src;
in {
  inherit name src;

  # Inputs to be available at build time
  nativeBuildInputs = [
    gdb
    go-task
    odin
    clang
    llvm_17
  ];

  buildPhase = ''
  # Inputs to be available at runtime
  buildInputs = [
  ];
    odin build ${src}/main -out:${name}
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp ${name} $out/bin
  '';
})
