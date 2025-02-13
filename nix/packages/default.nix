{
  stdenv,
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

  # Inputs to be available at runtime
  buildInputs = [
  ];
}
