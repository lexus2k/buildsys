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
define inner-package-make

ifneq ($(wildcard $($(1)_SRCDIR)/Makefile),)

ifndef $(1)_CONFIGURE_CMDS
define $(1)_CONFIGURE_CMDS
	@echo "Configure step is not required"
endef
endif

$(call inner-package-generic,$(1))
else
$(1):
	@echo "=== $(1): SKIPPED, no sources ==="
endif
endef

package-make = $(call inner-package-make,$(PKG))

