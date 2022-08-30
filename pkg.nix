{ stdenv, dpkg }:

let version = "8.0.3.654";
in stdenv.mkDerivation {
  pname = "perimeter81";
  inherit version;
  src = builtins.fetchurl {
    url =
      "https://static.perimeter81.com/agents/linux/Perimeter81_${version}.deb";
    sha256 = "0m1fyvvkdjvcs09aizvqpzr2xcybffqmpgdymwa4lwz7rizyxy81";
  };
  nativeBuildInputs = [ dpkg ];
  unpackPhase = ''
    dpkg-deb -x $src .
  '';
  installPhase = ''
    mkdir -p $out/{bin,opt/share}
    cp -r opt $out/
    cp -r usr/share $out/

    cp $out/opt/Perimeter81/perimeter81 $out/bin/
  '';
  postFixup = ''
    substituteInPlace $out/share/applications/perimeter81.desktop \
      --replace "/opt/Perimeter81/perimeter81" $out/opt/Perimeter81/perimeter81
    '';
}
