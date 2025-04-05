PACKAGE=libX11
$(package)_version=1.6.2
$(package)_download_path=http://xorg.freedesktop.org/releases/individual/lib/
$(package)_file_name=$(package)-$($(package)_version).tar.bz2
$(package)_sha256_hash=2aa027e837231d2eeea90f3a4afe19948a6eb4c8b2bec0241eba7dbc8106bd16
$(package)_dependencies=libxcb xtrans xextproto xproto kbproto inputproto

define $(package)_set_vars
  $(package)_config_opts=--enable-static --disable-shared --disable-xkb
  $(package)_config_opts_linux=--with-pic
  $(package)_config_opts += --prefix=$($(package)_type)_prefix)
endef

define $(package)_config_cmds
  $($(package)_autoconf)
endef

define $(package)_build_cmds
  $(MAKE)
endef

define $(package)_stage_cmds
  $(MAKE) DESTDIR=$($(package)_staging_dir) install
endef