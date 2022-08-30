{ stdenv, lib, dpkg, gcc-unwrapped, glibc }:

let 
  version = "8.0.3.654";
  rpath = lib.makeLibraryPath [ gcc-unwrapped glibc ] + ":${stdenv.cc.cc.lib}/lib64";
in stdenv.mkDerivation {
  name = "Perimeter81-${version}";
  inherit version;
  src = builtins.fetchurl {
    url =
      "https://static.perimeter81.com/agents/linux/Perimeter81_${version}.deb";
    sha256 = "0m1fyvvkdjvcs09aizvqpzr2xcybffqmpgdymwa4lwz7rizyxy81";
  };
  buildInputs = [ dpkg ];
  unpackPhase = "true";
  installPhase = ''
    mkdir -p $out
    dpkg -x $src $out
    cp -av $out/opt/Perimeter81/perimeter81 $out
    rm -rf $out/opt
  '';
  postFixup = ''
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/perimeter81 || true
    patchelf --set-rpath ${rpath} $out/perimeter81 || true
    '';
}
