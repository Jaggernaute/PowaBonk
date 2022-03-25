#=============================================================================
# variables definition

SHELL := /bin/bash
build_path := ./build/
ARROW := \033[1m\033[31m>\033[32m>\033[33m>\033[39m
CL_GREEN := \033[32m
CL_RESET := \033[39m


#=============================================================================
# Default target executed when no arguments are given to make.

default_target: all


#=============================================================================
# Build the sources with cmake.

build_sources:
	@
	@ # Loading progressbar
	@ echo -e "${ARROW} Building ..."
	cmake CMakelists.txt -B ${build_path}
	@ echo -e "[${CL_GREEN}OK${CL_RESET}] CMake build finished"


#=============================================================================
# Compile the Cmake generated MOC files.

compile:
	@ echo -e "\n${ARROW} Compiling..."
	make -C ${build_path}
	@ echo -e "[${CL_GREEN}OK${CL_RESET}] Compiling finished"


#=============================================================================
# Compile the Cmake generated MOC files (with minimal logs).

compile_quiet:
	@ echo -e "\n${ARROW} Compiling..."
	make -C ${build_path} -s
	@ echo -e "[${CL_GREEN}OK${CL_RESET}] Compiling finished"


#=============================================================================
# Run the app (from the newly created binary)
run:
	@ echo -e "\n${ARROW} Running..."
	./${build_path}powa_bonk
	@ echo -e "[${CL_GREEN}OK${CL_RESET}] Running"


#=============================================================================
# Build and run the app

 all: build_sources compile_quiet run
