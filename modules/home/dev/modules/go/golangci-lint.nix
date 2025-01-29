{
  pkgs ? import <nixpkgs> { },
}:

let
  version = "1.64.6";
  golangci-lint-pinned = pkgs.stdenv.mkDerivation {
    pname = "golangci-lint";
    version = "v${version}"; # Specify the desired version

    src = pkgs.fetchzip {
      url = "https://github.com/golangci/golangci-lint/releases/download/v${version}/golangci-lint-${version}-linux-amd64.tar.gz"; # Adjust URL for your OS/arch
      sha256 = "sha256-of-the-downloaded-archive"; # IMPORTANT: replace with actual hash
    };

    installPhase = ''
      mkdir -p $out/bin
      mv golangci-lint $out/bin/
    '';
  };
in
pkgs.mkShell {
  buildInputs = [ golangci-lint-pinned ];
}
