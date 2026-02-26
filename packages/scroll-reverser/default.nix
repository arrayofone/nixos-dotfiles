{
  lib,
  stdenv,
  fetchzip,
}:
let
  version = "1.9";
in
stdenv.mkDerivation {
  pname = "scroll-reverser";
  inherit version;

  src = fetchzip {
    url = "https://github.com/pilotmoon/Scroll-Reverser/releases/download/v${version}/ScrollReverser-${version}.zip";
    sha256 = "sha256-cK/hM8Qq2w/zWYY8OQFtAcixahnmg26hyqikVg5OpTw=";
    stripRoot = false;
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r "Scroll Reverser.app" $out/Applications/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Reverse the direction of scrolling on macOS";
    homepage = "https://pilotmoon.com/scrollreverser/";
    license = licenses.asl20;
    platforms = platforms.darwin;
    sourceProvenance = [ sourceTypes.binaryNativeCode ];
    maintainers = [ ];
  };
}
