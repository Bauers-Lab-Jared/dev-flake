{
  stdenv,
  odin,
  clang,
  llvm_17,
  go-task,
  qqwing,
  gdb,
}:
stdenv.mkDerivation (let
  name = "odin-sudoku";
  src = ./src;
in {
  inherit name src;

  nativeBuildInputs = [
    gdb
    go-task
    odin
    clang
    llvm_17
    qqwing
  ];

  buildPhase = ''
    odin build ${src}/main -out:${name}
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp ${name} $out/bin
  '';
})
