{
  stdenv,
  odin,
  clang,
  llvm_17,
  go-task,
  gdb,
}:
stdenv.mkDerivation (let
  name = "proj-name";
  src = ./src;
in {
  inherit name src;

  nativeBuildInputs = [
    gdb
    go-task
    odin
    clang
    llvm_17
  ];

  buildPhase = ''
    odin build ${src}/main -out:${name}
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp ${name} $out/bin
  '';
})
