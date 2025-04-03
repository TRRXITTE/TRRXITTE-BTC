package=boost
$(package)_version=1.87.0
$(package)_download_path=https://archives.boost.io/release/$($(package)_version)/source/
$(package)_file_name=boost_$(subst .,_,$($(package)_version)).tar.gz
$(package)_sha256_hash=f55c340aa49763b1925ccf02b2e83f35fdcf634c9d5164a2acb87540173c741d

define $(package)_set_vars
  $(package)_config_opts_release=variant=release
  $(package)_config_opts_debug=variant=debug
  $(package)_config_opts=--layout=tagged --build-type=complete --user-config=user-config.jam
  $(package)_config_opts+=threading=multi link=static -sNO_BZIP2=1 -sNO_ZLIB=1
  $(package)_config_opts_linux=target-os=linux threadapi=pthread runtime-link=shared
  $(package)_config_opts_darwin=target-os=darwin runtime-link=shared
  $(package)_config_opts_mingw32=target-os=windows binary-format=pe runtime-link=static threadapi=win32
  $(package)_config_opts_x86_64_mingw32=address-model=64
  $(package)_config_opts_i686_mingw32=address-model=32
  $(package)_config_opts_i686_linux=address-model=32 architecture=x86
  $(package)_config_opts_i686_android=address-model=32
  $(package)_config_opts_aarch64_android=address-model=64
  $(package)_config_opts_x86_64_android=address-model=64
  $(package)_config_opts_armv7a_android=address-model=32
  # Compilers
  $(package)_cxx_darwin=/home/traaitt/bitcoin/depends/x86_64-apple-darwin16/native/bin/clang++
  $(package)_cxx_mingw32=x86_64-w64-mingw32-g++
  # Toolsets
  $(package)_toolset_darwin=clang
  $(package)_toolset_mingw32=gcc
  $(package)_toolset_linux=gcc
  $(package)_archiver_darwin=$($(package)_ar)
  $(package)_archiver_mingw32=$($(package)_ar)
  $(package)_config_libraries=chrono,filesystem,system,thread,test,program_options
  $(package)_cxxflags=-std=c++17 -fvisibility=hidden
  $(package)_cxxflags_linux=-fPIC
  $(package)_cxxflags_darwin=-fPIC -isysroot /home/traaitt/bitcoin/depends/SDKs/MacOSX11.3.sdk -target x86_64-apple-darwin16
  $(package)_cxxflags_mingw32=-DWIN32 -D_WIN32 -D__USE_MINGW_ANSI_STDIO=1
endef

define $(package)_preprocess_cmds
  echo "using $($(package)_toolset_$(host_os)) : : $($(package)_cxx_$(host_os)) : <cxxflags>\"$($(package)_cxxflags) $($(package)_cppflags)\" <linkflags>\"$($(package)_ldflags)\" <archiver>\"$($(package)_archiver_$(host_os))\" <striper>\"$(host_STRIP)\" <ranlib>\"$(host_RANLIB)\" <rc>\"$(host_WINDRES)\" : ;" > user-config.jam
endef

define $(package)_config_cmds
  ./bootstrap.sh --without-icu --with-libraries=$($(package)_config_libraries) --with-toolset=$($(package)_toolset_$(host_os)) CXX=$($(package)_cxx_$(host_os))
endef

define $(package)_build_cmds
  NPROC=$$(nproc 2>/dev/null || echo 4); \
  ./b2 -d2 --prefix=$($(package)_staging_prefix_dir) $($(package)_config_opts) toolset=$($(package)_toolset_$(host_os)) stage
endef

define $(package)_stage_cmds
  NPROC=$$(nproc 2>/dev/null || echo 4); \
  ./b2 -d0--prefix=$($(package)_staging_prefix_dir) $($(package)_config_opts) toolset=$($(package)_toolset_$(host_os)) install
endef