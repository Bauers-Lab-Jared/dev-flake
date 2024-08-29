{
  buildGoApplication,
  # Args for this func will be sourced by nixpkgs automatically
}:
buildGoApplication {
  pname = "myapp";
  version = "0.1";
  pwd = ./.;
  src = ./.;
  modules = ./gomod2nix.toml;
}
