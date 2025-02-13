{
  stdenv,
  go-task,
  apio,
  icestorm,
}:
stdenv.mkDerivation {
  pname = "proj-name";
  version = "0.1";
  src = ../../src/main;

  # Inputs to be available at build time
  nativeBuildInputs = [
    go-task
    apio
    icestorm
  ];

  # Inputs to be available at runtime
  buildInputs = [
  ];
}
