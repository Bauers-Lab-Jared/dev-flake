{
  stdenv,
  digital,
  temurin-jre-bin,
  go-task,
  apio,
  icestorm,
  yosys,
  yosys-ghdl,
  nextpnr,
  graphviz-nox,
  iverilog,
  ghdl,
  gtkwave,
  verilator,
  mcy,
  aiger,
  avy,
  boolector,
  yices,
  z3,
  bitwuzla,
}:
stdenv.mkDerivation {
  pname = "proj-name";
  version = "0.1";
  src = ../../src/main;

  # Inputs to be available at build time
  nativeBuildInputs = [
    go-task
    temurin-jre-bin
    digital
    apio
    icestorm
    yosys
    yosys-ghdl
    nextpnr
    graphviz-nox
    iverilog
    ghdl
    gtkwave
    verilator
    mcy
    aiger
    avy
    boolector
    yices
    z3
    bitwuzla
  ];

  _JAVA_AWT_WM_NONREPARENTING = "1";

  # Inputs to be available at runtime
  buildInputs = [
  ];
}
