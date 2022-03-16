{ lib, stdenv, fetchFromGitHub, pcsclite, cmake, pkg-config }:

stdenv.mkDerivation rec {
  pname = "hexio";
  version = "1.1-RC1";

  src = fetchFromGitHub {
    owner = "vanrein";
    repo = pname;
    rev = "version-${version}";
    hash = "sha256-4Jg9OwnpMaXgjYa/EbYSuM/Oh4c/cvw7WoKj9ogpKXg=";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ pcsclite ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp devio hexin hexout pcscio $out/bin

    runHook postInstall
  '';

  meta = with lib; {
    description = "Low-level I/O helpers for hexadecimal, tty/serial devices and so on";
    homepage = "https://github.com/vanrein/hexio";
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ leenaars ];
  };
}
