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
# Build all targets (default)

build_sources:
	@ echo -e "${ARROW} Building ..."
	@ cmake CMakelists.txt -B ${build_path}
	@ echo -e "[${CL_GREEN}OK${CL_RESET}] CMake build finished"
	@
	@ echo -e "${ARROW} Compiling..."
	@ make -C ${build_path}
	@ echo -e "[${CL_GREEN}OK${CL_RESET}] Compiling finished"


#=============================================================================
# Build all targets (default) with no logs

build_sources_quiet:
	@ echo -e "${ARROW} Building ..."
	@ cmake CMakelists.txt -B ${build_path}
	@ echo -e "[${CL_GREEN}OK${CL_RESET}] CMake build finished"
	@
	@ echo -e "${ARROW} Compiling..."
	@ make -C ${build_path} -s
	@ echo -e "[${CL_GREEN}OK${CL_RESET}] Compiling finished"


#=============================================================================
# Run the app (from the newly created binary)
run:
	@ echo -e "${ARROW} Running..."
	@ ./${build_path}powa_bonk
	@ echo -e "[${CL_GREEN}OK${CL_RESET}] Running"


#=============================================================================
# Build and run the app

 all: build_sources run
