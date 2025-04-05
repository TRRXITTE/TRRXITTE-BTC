WINDOWS BUILD NOTES
====================

Some notes on how to build Bitcoin Core for Windows.

Most developers use cross-compilation from Ubuntu to build executables for
Windows. This is also used to build the release binaries.

Building on Windows itself is possible (for example using msys / mingw-w64),
but no one documented the steps to do this. If you are doing this, please contribute them.

Cross-compilation
-------------------

These steps can be performed on, for example, an Ubuntu VM. The depends system
will also work on other Linux distributions, however the commands for
installing the toolchain will be different.

Make sure you install the build requirements mentioned in
[build-unix.md](/doc/build-unix.md).
Then, install the toolchains and curl:

    sudo apt-get install g++-mingw-w64-i686 mingw-w64-i686-dev g++-mingw-w64-x86-64 mingw-w64-x86-64-dev curl

To build executables for Windows 32-bit:

    cd depends
    make HOST=i686-w64-mingw32 -j4
    cd ..
    ./configure --prefix=`pwd`/depends/i686-w64-mingw32
    make

To build executables for Windows 64-bit:

cd bitcoin
./autogen.sh
cd depends
export PKG_CONFIG_PATH=~/bitcoin/depends/x86_64-w64-mingw32/lib/pkgconfig:$PKG_CONFIG_PATH
make HOST=x86_64-w64-mingw32 -j$(nproc)
cd ..
  ./configure \
  --host=x86_64-w64-mingw32 \
  --prefix=$HOME/bitcoin/depends/x86_64-w64-mingw32 \
  CXXFLAGS="$(echo $CXXFLAGS | sed 's/-Werror//') -Wno-placement-new -Wno-deprecated-declarations" \
  CPPFLAGS="-I$HOME/bitcoin/depends/x86_64-w64-mingw32/include" \
  LDFLAGS="-L$HOME/bitcoin/depends/x86_64-w64-mingw32/lib" \
  --with-miniupnpc=no --disable-tests --disable-bench
make -j$(nproc)

For further documentation on the depends system see [README.md](../depends/README.md) in the depends directory.

