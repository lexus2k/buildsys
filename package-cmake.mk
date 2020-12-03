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
define inner-package-cmake

ifneq ($(wildcard $($(1)_SRCDIR)/CMakeLists.txt),)

$(1)_INSTALL_OPTS ?= DESTDIR=$(STAGING_DIR) install

ifndef $(1)_CONFIGURE_CMDS
# Configure for target
# should use (HOST_DIR)/usr/bin/cmake. For now use system cmake
define $(1)_CONFIGURE_CMDS
	(cd $$($(1)_SRCDIR) && \
	rm -f CMakeCache.txt && \
	$$($(1)_CONF_ENV) $$(CMAKE_CROSS_ENV) cmake $$($(1)_SRCDIR) $$(CMAKE_CROSS_OPTS) \
	    $$($(1)_CONF_OPTS))
endef
endif

$(call inner-package-generic,$(1))

else

$(1):
	@echo "=== $(1): SKIPPED, no sources ==="

endif

endef

package-cmake = $(call inner-package-cmake,$(PKG))
