print-info=echo "\033[33m$(1)\033[0m"
print-status=echo "\033[36m$(1)\033[0m"
print-ok=echo "\033[32m$(1)\033[0m"
print-error=echo "\033[31m$(1)\033[0m"

include buildsys/toolchain.mk
include buildsys/host-toolchain.mk
include buildsys/project.mk
include buildsys/package-generic.mk
include buildsys/package-make.mk
include buildsys/package-cmake.mk
include buildsys/host-package-generic.mk
include buildsys/host-package-cmake.mk
