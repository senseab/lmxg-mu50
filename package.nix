{
  stdenv,
  fetchurl,

  # dependencies
  mame,
  p7zip,
  ...
}:
let
  bin = ./lmxg-mu50;
  desktop = ./lmxg-mu50.desktop;
  icon = ./lmxg-mu50.png;
in
stdenv.mkDerivation rec {
  pname = "lmxg-mu50";
  version = "0.1.0";

  src = fetchurl {
    url = "https://mdk.cab/download/nonmerged/mu50";
    sha256 = "sha256-0hzR2EWmamLJrqJ6cXaReEgd8Ha4Sf7LENpIYqcbCgs=";
  };

  nativeBuildInputs = [
    p7zip
  ];

  buildInputs = [
    mame
  ];

  phases = [
    "unpackPhase"
    "installPhase"
  ];

  unpackPhase = ''
    mkdir -p mu50
    cd mu50
    7z x $src
    cd ../
  '';

  installPhase = ''
    mkdir -p $out/bin
    cat ${bin} | sed "s|@DIR@|$out|" | sed "s|@MAME_BIN_DIR@|${mame}/bin|" > $out/bin/${pname}
    chmod +x $out/bin/${pname}
    mkdir -p $out/share/applications
    cat ${desktop} | sed "s|@EXEC@|$out/bin/${pname}|" > $out/share/applications/${pname}.desktop
    mkdir -p $out/share/pixmaps
    cp ${icon} $out/share/pixmaps/${pname}.png
 
    mkdir -p $out/share/mame/assets/mu50

    cp -r /build/mu50 $out/share/mame/assets/
  '';
}
