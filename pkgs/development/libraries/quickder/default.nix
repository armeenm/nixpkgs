{ lib, stdenv, fetchFromGitLab
, python3Packages
, arpa2cm
, asn2quickder
, bash
, cmake
, git
}:

stdenv.mkDerivation rec {
  pname = "quickder";
  version = "1.7.0";

  src = fetchFromGitLab {
    owner = "arpa2";
    repo = "quick-der";
    rev = "v${version}";
    hash = "sha256-/tro6jcdqbo7aLU5HCJ221VTcFKc4ELNHE/HGoElaHI=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = with python3Packages; [
    arpa2cm
    asn1ate
    colored
    pyparsing
    python
    six
  ];

  #postPatch = ''
  #  substituteInPlace ./CMakeLists.txt \
  #    --replace "get_version_from_git" "set (Quick-DER_VERSION 1.2) #"
  #  substituteInPlace ./CMakeLists.txt \
  #    --replace \$\{ARPA2CM_TOOLCHAIN_DIR} "$out/share/ARPA2CM/toolchain/"
  #  patchShebangs python/scripts/
  #'';

  #cmakeFlags = [
  #  "-DNO_TESTING=ON"
  #  "-DARPA2CM_TOOLCHAIN_DIR=$out/share/ARPA2CM/toolchain/"
  #];

  preConfigure = ''
    export PREFIX=$out
  '';

  meta = with lib; {
    description = "Quick (and Easy) DER, a Library for parsing ASN.1";
    homepage = "https://github.com/vanrein/quick-der";
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ leenaars ];
  };
}
