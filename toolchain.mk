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

PLATFORM ?= linux
ROOT_CACHE_DIR ?= $(shell pwd)/bld
STAGING_DIR ?= $(ROOT_CACHE_DIR)/staging
TARGET_DIR ?= $(ROOT_CACHE_DIR)/target
HOST_DIR ?= $(ROOT_CACHE_DIR)/host
PKG_CONFIG ?= pkg-config
DESTDIR ?=
ROOT_DIR=$(PWD)

include buildsys/platform-$(PLATFORM).mk

CROSS_COMPILE ?=

ifneq ($(CROSS_COMPILE),)
CXX= $(CROSS_COMPILE)g++
CC= $(CROSS_COMPILE)gcc
AR= $(CROSS_COMPILE)ar
HOST_SYSROOT ?= n
else
HOST_SYSROOT ?= y
endif


PKG_CONFIG_CROSS_ENV = \
	PKG_CONFIG_PATH="$(STAGING_DIR)/usr/lib/pkgconfig" \

ifeq ($(HOST_SYSROOT),y)
CPPFLAGS += -I$(STAGING_DIR)/include -I$(STAGING_DIR)/usr/include
LDFLAGS += -L$(STAGING_DIR)/lib -L$(STAGING_DIR)/usr/lib
else
PKG_CONFIG_CROSS_ENV += \
	PKG_CONFIG=$(PKG_CONFIG) \
	PKG_CONFIG_SYSROOT_DIR="$(STAGING_DIR)" \
	PKG_CONFIG_LIBDIR=$(STAGING_DIR)/usr/lib/pkgconfig
endif

MAKE_CROSS_ENV := \
	PATH="$(HOST_DIR)/bin:$(HOST_DIR)/usr/bin:$(PATH)" \

CROSS_ENV = \
	$(MAKE_CROSS_ENV) \
        CXX=$(CXX) \
        CC=$(CC) \
	CPP="$(CPP)" \
        AR=$(AR) \
	LD="$(LD)" \
	AS="$(AS)" \
	NM="$(NM)" \
	$(PKG_CONFIG_CROSS_ENV) \
	CFLAGS="$(CFLAGS)" \
	CXXFLAGS="$(CXXFLAGS)" \
	CPPFLAGS="$(CPPFLAGS)" \
	LDFLAGS="$(LDFLAGS)"

#    RANLIB="-ranlib" \
#    READELF="-readelf" \
#    STRIP="-strip" \
#    OBJCOPY="-objcopy" \
#    OBJDUMP="-objdump" \
#    STAGING_DIR=$(STAGING_DIR) \

CMAKE_CROSS_ENV := $(CROSS_ENV) \
	CFLAGS="$(CFLAGS) $(CPPFLAGS)" \
	CXXFLAGS="$(CXXFLAGS) $(CPPFLAGS)" \
	CPPFLAGS="$(CPPFLAGS)" \
	LDFLAGS="$(LDFLAGS)"

CMAKE_CROSS_OPTS := -DCMAKE_INSTALL_PREFIX="/usr" \
	-DCMAKE_PROGRAM_PATH="/usr/bin" \
	-DCMAKE_FIND_ROOT_PATH="$(STAGING_DIR)" \
	-DCMAKE_FIND_ROOT_PATH_MODE_PROGRAM="NEVER" \
	-DCMAKE_FIND_ROOT_PATH_MODE_PACKAGE="ONLY" \
	-DCMAKE_FIND_ROOT_PATH_MODE_LIBRARY="ONLY" \
	-DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE="ONLY" \
	-DBUILD_DOC=OFF \
	-DBUILD_DOCS=OFF \
	-DBUILD_EXAMPLE=OFF \
	-DBUILD_EXAMPLES=OFF \
	-DBUILD_TEST=OFF \
	-DBUILD_TESTS=OFF \
	-DBUILD_TESTING=OFF \

