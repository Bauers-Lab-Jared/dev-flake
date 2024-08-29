{
  stdenv,
  odin,
  clang,
  llvm_17,
  go-task,
  gdb,
  # Args for this func will be sourced by nixpkgs automatically
}:
stdenv.mkDerivation rec {
  pname = "projectName";
  version = "0.1";
  src = ./src;

  # Inputs to be available at build time
  nativeBuildInputs = [
    gdb
    go-task
    odin
    clang
    llvm_17
  ];

  # Inputs to be available at runtime
  buildInputs = [
  ];

  buildPhase = ''
    odin build ./main/ \
    -out:${pname}
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp ${pname} $out/bin
  '';
}
