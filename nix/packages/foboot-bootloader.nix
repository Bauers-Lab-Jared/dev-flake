{
  lib,
  stdenv,
  fetchurl,
}:
stdenv.mkDerivation rec {
  pname = "foboot";
  version = "v2.0.4";

  src = fetchurl {
    url = "https://github.com/im-tomu/foboot/releases/download/${version}/pvt-updater-${version}.dfu";
    sha256 = "0vf12pa5119j63jwnwjh2hkgvznslx03mhg4j8z1bz7fhlw4qz5n";
  };

  meta = with lib; {
    license = licenses.asl20;
  };
}
