{
  stdenv, lib,
  fetchFromGitHub,
  cmake,
  lzo,
  openssl,
  perl,
  python3,
  snappy,
  which,
  zlib
}:

let
  updateCheckFiles = [
    "js/client/client.js"
    "js/server/server.js"
    "js/server/bootstrap/coordinator.js"
  ];

  common = { version, hash }: stdenv.mkDerivation {
    pname = "arangodb";
    inherit version;

    src = fetchFromGitHub {
      repo = "arangodb";
      owner = "arangodb";
      rev = "v${version}";
      inherit hash;
    };

    #patches = [ ./tmp.patch ];

    nativeBuildInputs = [ cmake python3 perl which ];
    buildInputs = [ openssl zlib snappy lzo ];

    postPatch = ''
      for i in 3rdParty/V8/gypfiles/*.gypi; do
        substituteInPlace "$i" --replace /bin/echo echo
      done

      # Disable update checks
      for i in $updateCheckFiles; do
        substituteInPlace "$i" --replace "require('@arangodb').checkAvailableVersions();" ""
      done

      # Delete obsolete symlink (https://github.com/arangodb/arangodb/pull/15441)
      rm cmake/RocksDBConfig.cmake.in

      patchShebangs utils/*.sh
    '';

    cmakeFlags = [
      # Avoid using builder's /proc/cpuinfo
      "-DUSE_OPTIMIZE_FOR_ARCHITECTURE=OFF"
      "-DHAVE_SSE42=${if stdenv.hostPlatform.sse4_2Support then "ON" else "OFF"}"
      "-DASM_OPTIMIZATIONS=${if stdenv.hostPlatform.sse4_2Support then "ON" else "OFF"}"
    ];

    postInstall = ''
      rm -rf $out/var
    '';

    meta = with lib; {
      homepage = "https://www.arangodb.com";
      description = "A native multi-model database with flexible data models for documents, graphs, and key-values";
      license = licenses.asl20;
      platforms = platforms.linux;
      maintainers = [ maintainers.flosse ];
    };
  };
in {
  arangodb_3_7 = common {
    version = "3.7.17";
    hash = "sha256-M5FM7RuFBGCZrbSORzKqWqUuaCK+QUSYJzQg0c1vga8=";
  };
  arangodb_3_8 = common {
    version = "3.8.6";
    hash = "sha256-z8QzNkp4ZB1pEeZ6qKz8/uPB5VOEFuFbX9wAlYFuFvQ=";
  };
}
