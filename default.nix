{
  stdenv,
  go-task,
  # Args for this func will be sourced by nixpkgs automatically
  #Examples:
  # odin,
  # clang,
  # llvm_17,
  # qqwing,
  # gdb,
}:
stdenv.mkDerivation (let
  name = "proj-name";
  src = ./src;
in {
  inherit name src;

  # Inputs to be available at build time
  nativeBuildInputs = [
    go-task
    #Examples
    # gdb
    # odin
    # clang
    # llvm_17
    # qqwing
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
