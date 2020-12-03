default: libsimple

include buildsys/main.mk

##################################################################

CFLAGS += -std=gnu99
CPPFLAGS += -Os -Wall -Werror -ffunction-sections -fdata-sections
CXXFLAGS += -std=c++11

####################### Compiling library #########################
PKG = libsimple
$(PKG)_SOURCES = src/source.c
$(PKG)_CPPFLAGS += -I./src
$(PKG)_PKGCONFIG = simple.pc
$(PKG)_CMAKE_MODULE = Findsimple.cmake
$(eval $(project-static-lib))
