#
# This is build system for small libraries and projects.
# Copyright (C) 2020 Alexey Dynda
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#

# $1 package name
define host-inner-package-generic

$(1)_DEPENDENCIES ?=
$(1)_SRCDIR ?=
$(1)_SUBDIR ?=
$(1)_CONF_ENV ?=
$(1)_CONF_OPTS ?=
$(1)_MAKE_ENV ?=
$(1)_MAKE_OPTS ?=
$(1)_CLEAN_OPTS ?= clean
$(1)_PKGCONFIG ?=
$(1)_INSTALL_OPTS ?= DESTDIR= install
# $(HOST_DIR) install
$(1)_INSTALL_TARGET ?= YES

.PHONY: $(1)_clean $(1)

ifndef $(1)_CONFIGURE_CMDS
define $(1)_CONFIGURE_CMDS
	(cd $$($(1)_SRCDIR) && $$(AUTORECONF))
	(cd $$($(1)_SRCDIR) && rm -rf config.cache && \
	     $$(HOST_CROSS_ENV) \
	     $$($(1)_CONF_ENV) \
	     CONFIG_SITE=/dev/null \
	     ./configure \
	     --prefix="$$(HOST_DIR)/usr" \
	     --sysconfdir="$$(HOST_DIR)/etc" \
	     --localstatedir="$$(HOST_DIR)/var" \
	     --enable-shared --disable-static \
	     --disable-gtk-doc \
	     --disable-gtk-doc-html \
	     --disable-doc \
	     --disable-docs \
	     --disable-documentation \
	     --disable-debug \
	     --with-xmlto=no \
	     --with-fop=no \
	     --disable-dependency-tracking \
	     $$($(1)_CONF_OPTS) \
	)
endef
endif

#	     --prefix="$$(HOST_DIR)/usr" \

ifndef $(1)_BUILD_CMDS
define $(1)_BUILD_CMDS
	$$(HOST_CROSS_ENV) $$($(1)_MAKE_ENV) $$(MAKE) -C $($(1)_SRCDIR)$($(1)_SUBDIR) $$($(1)_MAKE_OPTS)
endef
endif

ifndef $(1)_INSTALL_CMDS
define $(1)_INSTALL_CMDS
	$$(MAKE) -C $($(1)_SRCDIR)$($(1)_SUBDIR) $$($(1)_INSTALL_OPTS)
	@mkdir -p $(HOST_DIR)/usr/lib/pkgconfig $(HOST_DIR)/usr/share/cmake $(HOST_DIR)/usr/include
	@for i in $$($(1)_PKGCONFIG); do \
	    cp -f $$$${i} $(HOST_DIR)/usr/lib/pkgconfig/; \
	done
	@for i in $$($(1)_CMAKE_MODULE); do \
	    cp -f $$$${i} $(HOST_DIR)/usr/share/cmake/; \
	done
endef
endif

$($(1)_SRCDIR)/.host_ts_deps: | $($(1)_DEPENDENCIES)
	@$(call print-info, "=== Building $(1) ===")
	@touch $$@

$($(1)_SRCDIR)/.host_ts_conf: $($(1)_SRCDIR)/.host_ts_deps
	$$($(1)_CONFIGURE_CMDS)
	@$(call print-status, "=== Configuring $(1) done ===")
	@touch $$@

$($(1)_SRCDIR)/.host_ts_build: PKG_SRCDIR=$($(1)_SRCDIR)
$($(1)_SRCDIR)/.host_ts_build: $($(1)_SRCDIR)/.host_ts_conf
	$$($(1)_BUILD_CMDS)
	$(foreach hook,$($(1)_POST_BUILD_HOOKS),$$(call $(hook)))
	@$(call print-status, "=== Build $(1) done ===")
	@touch $$@

$($(1)_SRCDIR)/.host_ts_install: $($(1)_SRCDIR)/.host_ts_build
	$$($(1)_INSTALL_CMDS)
	@$(call print-status, "=== Install $(1) done ===")
	@touch $$@

ifeq ($$($(1)_INSTALL_TARGET),YES)
$(1): $($(1)_SRCDIR)/.host_ts_install
else
$(1): $($(1)_SRCDIR)/.host_ts_build
endif

$(1)_clean:
	@rm -f $($(1)_SRCDIR)/.host_ts_*
	-$(MAKE) -C $($(1)_SRCDIR)$($(1)_SUBDIR) $$($(1)_CLEAN_OPTS)
	@$(call print-ok, "=== Clean $(1) done ===")

clean: $(1)_clean

$(1):
	@$(call print-ok, "=== OK $(1) ===")

endef

host-package-generic = $(call host-inner-package-generic,$(PKG))
