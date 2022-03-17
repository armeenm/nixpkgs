{ stdenv
, lib
, fetchFromGitHub
, boost
, cmake
, gfortran
, pkg-config
, python3
, texinfo
  # Select SIMD alignment width (in bytes) for vectorization.
, simdWidth ? 1
  # Pad arrays to simdWidth by default?
  # Note: Only useful if simdWidth > 1
, enablePadding ? false
  # Activate serialization through Boost.Serialize?
, enableSerialization ? true
  # Activate test-suite?
  # WARNING: Some of the tests require up to 1700MB of memory to compile.
, doCheck ? true
}:

let
  inherit (lib) optional optionals;
in
stdenv.mkDerivation rec {
  pname = "blitz++";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "blitzpp";
    repo = "blitz";
    rev = version;
    hash = "sha256-wZDg+4lCd9iHvxuQQE/qs58NorkxZ0+mf+8PKQ57CDE=";
  };

  nativeBuildInputs = [
    cmake
    gfortran
    pkg-config
    python3 
    texinfo
  ];

  buildInputs = [
    boost 
  ];

  postBuild = "make testsuite";

  cmakeFlags = [
    "-DSIMD_EXTENSION=ON"
    "-DBZ_SIMD_WIDTH=${toString simdWidth}"
    #"-DBUILD_DOC=ON"
    "-DFORTRAN_BENCHMARKS=ON"
  ]
  ++ optional doCheck "-DBUILD_TESTING=ON"
  ++ optional enablePadding "-DARRAY_LENGTH_PADDING=ON"
  ++ optional enableSerialization "-DENABLE_SERIALISATION=ON"
  ++ optional stdenv.is64bit "-DBZ_FULLY64BIT=ON";

  inherit doCheck;
  #checkTarget = "build/check-testsuite check-examples";

  meta = with lib; {
    description = "Fast multi-dimensional array library for C++";
    homepage = "https://sourceforge.net/projects/blitz/";
    license = licenses.lgpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ToxicFrog ];
    longDescription = ''
      Blitz++ is a C++ class library for scientific computing which provides
      performance on par with Fortran 77/90. It uses template techniques to
      achieve high performance. Blitz++ provides dense arrays and vectors,
      random number generators, and small vectors (useful for representing
      multicomponent or vector fields).
    '';
  };
}
