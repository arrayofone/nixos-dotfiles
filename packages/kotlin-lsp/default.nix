{
  pkgs,
  stdenv,
  wrapGAppsHook3,
}:
let
  version = "0.253.10629";
in
stdenv.mkDerivation {
  name = "kotlin-lsp";

  src = pkgs.fetchzip {
    url = "https://download-cdn.jetbrains.com/kotlin-lsp/${version}/kotlin-${version}.zip";
    sha256 = "sha256-LCLGo3Q8/4TYI7z50UdXAbtPNgzFYtmUY/kzo2JCln0=";
    stripRoot = false;
  };

  nativeBuildInputs = [
    wrapGAppsHook3
  ];

  installPhase = ''
    mkdir -p $out/lib
    cp -r $src/* $out/lib
    chmod +x $out/lib/kotlin-lsp.sh

    mkdir -p $out/bin
    ln -s $out/lib/kotlin-lsp.sh $out/bin/kotlin-lsp
    wrapProgram $out/bin/kotlin-lsp
  '';

  meta = {
    mainProgram = "kotlin-lsp";
  };
}
