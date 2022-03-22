{ lib, stdenv, fetchFromGitHub, autoconf, automake, libtool, pkg-config, gnome
, gtk-doc, gtk2, python2Packages, lua, gobject-introspection
}:

let
  inherit (python2Packages) python pygtk;
in stdenv.mkDerivation rec {
  pname = "keybinder";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "engla";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-elL6DZtzCwAtoyGZYP0jAma6tHPks2KAtrziWtBENGU=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    autoconf automake libtool gnome.gnome-common gtk-doc gtk2
    python pygtk lua gobject-introspection
  ];

  preConfigure = ''
    ./autogen.sh --prefix="$out"
  '';

  meta = with lib; {
    description = "Library for registering global key bindings";
    longDescription = ''
      keybinder is a library for registering global keyboard shortcuts.
      Keybinder works with GTK-based applications using the X Window System.

      The library contains:

      * A C library, ``libkeybinder``
      * Gobject-Introspection (gir)  generated bindings
      * Lua bindings, ``lua-keybinder``
      * Python bindings, ``python-keybinder``
      * An ``examples`` directory with programs in C, Lua, Python and Vala.
    '';
    homepage = "https://github.com/engla/keybinder/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
