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

HOST_CPPFLAGS  = -I$(HOST_DIR)/usr/include
HOST_CFLAGS   += $(HOST_CPPFLAGS)
HOST_CXXFLAGS += $(HOST_CPPFLAGS)
HOST_LDFLAGS  += -L$(HOST_DIR)/lib -L$(HOST_DIR)/usr/lib -Wl,-rpath,$(HOST_DIR)/usr/lib
HOST_NAME   := $(shell buildsys/external/config.guess)

HOSTAR ?= ar
HOSTAS ?= as
HOSTCC ?= gcc
HOSTCXX ?= g++
HOSTCPP ?= cpp
HOSTLD ?= ld
HOSTLN ?= ln
HOSTNM ?= nm
HOSTOBJCOPY ?= objcopy
HOSTRANLIB ?= ranlib

AUTOMAKE ?= automake
ACLOCAL_DIR ?= $(STAGING_DIR)/usr/share/aclocal
ACLOCAL_HOST_DIR ?= $(HOST_DIR)/usr/share/aclocal
ACLOCAL ?= aclocal -I $(ACLOCAL_DIR)

AUTOCONF ?=  autoconf
AUTOHEADER ?= autoheader
AUTORECONF ?= $(HOST_CROSS_ENV) ACLOCAL="$(ACLOCAL)" AUTOCONF="$(AUTOCONF)" AUTOHEADER="$(AUTOHEADER)" \
	AUTOMAKE="$(AUTOMAKE)" AUTOPOINT=/bin/true autoreconf -f -i
ifneq ($(wildcard $(ACLOCAL_DIR)),)
AUTORECONF += -I "$(ACLOCAL_DIR)"
endif
ifneq ($(wildcard $(ACLOCAL_HOST_DIR)),)
AUTORECONF += -I "$(ACLOCAL_HOST_DIR)"
endif
AUTORECONF += -I "/usr/share/aclocal"

HOST_CROSS_ENV = \
	PATH="$(HOST_DIR)/bin:$(HOST_DIR)/usr/bin:$(PATH)" \
	AR="$(HOSTAR)" \
	AS="$(HOSTAS)" \
	LD="$(HOSTLD)" \
	NM="$(HOSTNM)" \
	CC="$(HOSTCC)" \
	GCC="$(HOSTCC)" \
	CXX="$(HOSTCXX)" \
	CPP="$(HOSTCPP)" \
	OBJCOPY="$(HOSTOBJCOPY)" \
	RANLIB="$(HOSTRANLIB)" \
	CPPFLAGS="$(HOST_CPPFLAGS)" \
	CFLAGS="$(HOST_CFLAGS)" \
	CXXFLAGS="$(HOST_CXXFLAGS)" \
	LDFLAGS="$(HOST_LDFLAGS)" \
	TARGET_DIR="$(HOST_DIR)" \
	PKG_CONFIG="pkg-config" \
	PKG_CONFIG_SYSROOT_DIR="/" \
	PKG_CONFIG_LIBDIR="$(HOST_DIR)/usr/lib/pkgconfig:$(HOST_DIR)/usr/share/pkgconfig" \
	LD_LIBRARY_PATH="$(HOST_DIR)/usr/lib$(if $(LD_LIBRARY_PATH),:$(LD_LIBRARY_PATH))" \
	PYTHONPATH="$(HOST_DIR)/usr/lib/python3/dist-packages:$(PYTHONPATH)"

HOST_CMAKE_CROSS_OPTS = -DCMAKE_INSTALL_SO_NO_EXE=0 \
	-DCMAKE_FIND_ROOT_PATH="$(HOST_DIR)" \
	-DCMAKE_FIND_ROOT_PATH_MODE_PROGRAM="BOTH" \
	-DCMAKE_FIND_ROOT_PATH_MODE_LIBRARY="BOTH" \
	-DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE="BOTH" \
	-DCMAKE_INSTALL_PREFIX="$(HOST_DIR)/usr" \
	-DCMAKE_C_FLAGS="$(HOST_CFLAGS)" \
	-DCMAKE_CXX_FLAGS="$(HOST_CXXFLAGS)" \
	-DCMAKE_EXE_LINKER_FLAGS="$(HOST_LDFLAGS)" \
	-DBUILD_DOC=OFF \
	-DBUILD_DOCS=OFF \
	-DBUILD_EXAMPLE=OFF \
	-DBUILD_EXAMPLES=OFF \
	-DBUILD_TEST=OFF \
	-DBUILD_TESTS=OFF \
	-DBUILD_TESTING=OFF







