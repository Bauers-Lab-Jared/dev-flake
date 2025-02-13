{
  lib,
  fetchurl,
}: let
  version = "v2.0.4";
in
  fetchurl {
    url = "https://github.com/im-tomu/foboot/releases/download/${version}/pvt-updater-${version}.dfu";
    sha256 = "0vf12pa5119j63jwnwjh2hkgvznslx03mhg4j8z1bz7fhlw4qz5n";
  }
