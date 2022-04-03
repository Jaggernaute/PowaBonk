#===============================================================================
# variables definition

SHELL := /bin/bash
build_path := ./build/
ARROW := \033[1m\033[31m>\033[32m>\033[33m>\033[39m
CL_GREEN := \033[32m
CL_RESET := \033[39m



#===============================================================================
# Default target executed when no arguments are given to make.

default_target: all


#===============================================================================
# Build the sources to ninja.

build_sources:
	@ if [ ! -d ${build_path} ]; then\
	   mkdir -p ${build_path};\
	fi
	@ echo -e "${ARROW} Building ..."
	cmake CMakelists.txt -G "Ninja" -B ${build_path}
	@ echo -e "[${CL_GREEN}OK${CL_RESET}] CMake build finished"


#===============================================================================
# Compile the Cmake generated MOC files.

compile:
	@ echo -e "\n${ARROW} Compiling..."
	@ ninja -C ${build_path} -v -l 100 -j 4 -k 0
	@ echo -e "[${CL_GREEN}OK${CL_RESET}] Compiling finished"


#=============================================================================
# Compile the Cmake generated MOC files (with minimal logs).

compile_quiet:
	@ echo -e "\n${ARROW} Compiling..."
	@ ninja -C ${build_path}
	@ echo -e "[${CL_GREEN}OK${CL_RESET}] Compiling finished"


#===============================================================================
# Run the app (from the newly created binary)
run:
	@ echo -e "\n${ARROW} Running..."
	./${build_path}powa_bonk
	@ echo -e "[${CL_GREEN}OK${CL_RESET}] Running"


#===============================================================================
# Cleaning build files and directories.
clean:
	@ echo -e "\n${ARROW} Cleaning..."
	@ rm -rf ${build_path};
	@ rm -rf ./cmake-build-*;



#===============================================================================
# Build and run the app

 all: build_sources compile_quiet run


#===============================================================================
# tests

tests:
	@ echo -e "\n${ARROW} Running tests..."
	@ if [ -d ${build_path} ]; then\
  	   rm -rf ${build_path}/*;\
  	  fi
	@ if [ ! -d ${build_path} ]; then\
 	   mkdir -p ${build_path};\
 	  fi
	@ cmake CMakelists.txt -B ${build_path}
	@ cd ${build_path}/test && make
	@ cd ${build_path}/test && ctest --coverage
	@ echo -e "[${CL_GREEN}OK${CL_RESET}] Running tests"
