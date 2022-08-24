{
  description = "Perimeter81 on Nix";
  inputs = { nixpkgs = { url = "nixpkgs/nixos-unstable"; }; };
  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      package = pkgs.callPackage ./pkg.nix { };
    in {
      packages.${system}.p81 = package;
      defaultPackage.x86_64-linux = package;
    };
}
