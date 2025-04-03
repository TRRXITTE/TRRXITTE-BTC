
package=native_clang
$(package)_version=16.0.0
$(package)_download_path=https://github.com/llvm/llvm-project/releases/download/llvmorg-$($(package)_version)
ifneq (,$(findstring aarch64,$(BUILD)))
$(package)_download_file=clang+llvm-$($(package)_version)-aarch64-linux-gnu.tar.xz
$(package)_file_name=clang+llvm-$($(package)_version)-aarch64-linux-gnu.tar.xz
$(package)_sha256_hash=684143b9d532f5ebfd9433b08e5d03e8a9b6569f05c9b0ec39f2b265137b8b98
else
$(package)_download_file=clang+llvm-$($(package)_version)-x86_64-linux-gnu-ubuntu-18.04.tar.xz
$(package)_file_name=clang+llvm-$($(package)_version)-x86_64-linux-gnu-ubuntu-18.04.tar.xz
$(package)_sha256_hash=2b8a69798e8dddeb57a186ecac217a35ea45607cb2b3cf30014431cff4340ad1
endif

define $(package)_preprocess_cmds
  rm -f $($(package)_extract_dir)/lib/libc++abi.so*
endef

define $(package)_stage_cmds
  mkdir -p $($(package)_staging_prefix_dir)/lib/clang/16/include && \
  mkdir -p $($(package)_staging_prefix_dir)/bin && \
  mkdir -p $($(package)_staging_prefix_dir)/include && \
  cp $($(package)_extract_dir)/bin/clang $($(package)_staging_prefix_dir)/bin/ && \
  cp -P $($(package)_extract_dir)/bin/clang++ $($(package)_staging_prefix_dir)/bin/ && \
  cp $($(package)_extract_dir)/bin/dsymutil $($(package)_staging_prefix_dir)/bin/$(host)-dsymutil && \
  cp $($(package)_extract_dir)/bin/llvm-config $($(package)_staging_prefix_dir)/bin/ && \
  cp $($(package)_extract_dir)/lib/libLTO.so $($(package)_staging_prefix_dir)/lib/ && \
  cp -rf $($(package)_extract_dir)/lib/clang/16/include/* $($(package)_staging_prefix_dir)/lib/clang/16/include/
endef

define $(package)_postprocess_cmds
  rmdir include
endef