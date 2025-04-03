OSX_MIN_VERSION=10.12
OSX_SDK_VERSION=11.3
SDK_PATH=/home/traaitt/bitcoin/depends/SDKs
OSX_SDK=$(SDK_PATH)/MacOSX$(OSX_SDK_VERSION).sdk
LD64_VERSION=609

darwin_native_binutils=native_cctools
darwin_native_toolchain=native_cctools

clang_prog=$(build_prefix)/bin/clang
clangxx_prog=$(clang_prog)++

clang_resource_dir=$(build_prefix)/lib/clang/16.0.0

cctools_TOOLS=AR RANLIB STRIP NM LIBTOOL OTOOL INSTALL_NAME_TOOL

# Make-only lowercase function
lc = $(subst A,a,$(subst B,b,$(subst C,c,$(subst D,d,$(subst E,e,$(subst F,f,$(subst G,g,$(subst H,h,$(subst I,i,$(subst J,j,$(subst K,k,$(subst L,l,$(subst M,m,$(subst N,n,$(subst O,o,$(subst P,p,$(subst Q,q,$(subst R,r,$(subst S,s,$(subst T,t,$(subst U,u,$(subst V,v,$(subst W,w,$(subst X,x,$(subst Y,y,$(subst Z,z,$1))))))))))))))))))))))))))

$(foreach TOOL,$(cctools_TOOLS),$(eval darwin_$(TOOL) = $$(build_prefix)/bin/$$(host)-$(call lc,$(TOOL))))

darwin_CC=$(clang_prog) --target=$(host) -mmacosx-version-min=$(OSX_MIN_VERSION) \
          -B$(build_prefix)/bin -mlinker-version=$(LD64_VERSION) \
          -isysroot $(OSX_SDK)

darwin_CXX=$(clangxx_prog) --target=$(host) -mmacosx-version-min=$(OSX_MIN_VERSION) \
           -B$(build_prefix)/bin -mlinker-version=$(LD64_VERSION) \
           -isysroot $(OSX_SDK) \
           -stdlib=libc++

darwin_CFLAGS=-pipe
darwin_CXXFLAGS=$(darwin_CFLAGS)

darwin_release_CFLAGS=-O2
darwin_release_CXXFLAGS=$(darwin_release_CFLAGS)

darwin_debug_CFLAGS=-O1
darwin_debug_CXXFLAGS=$(darwin_debug_CFLAGS)

darwin_cmake_system=Darwin