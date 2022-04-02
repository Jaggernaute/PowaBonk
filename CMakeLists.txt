cmake_minimum_required(VERSION 3.21)
project(powa_bonk)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

# Set the style of CMake output
set(CMAKE_VERBOSE_MAKEFILE ON)
set(CMAKE_COLOR_MAKEFILE ON)
set(CMAKE_BUILD_WITH_INSTALL_RPATH ON)

#set the build type
if(CMAKE_BUILD_TYPE)
  message(STATUS "CMAKE_BUILD_TYPE: ${CMAKE_BUILD_TYPE}")
else()
  set(CMAKE_BUILD_TYPE Debug)
  message(STATUS "CMAKE_BUILD_TYPE: ${CMAKE_BUILD_TYPE}")
endif()

message("Cmake logs: ")

#set the qt version
if(CMAKE_QT_VERSION)
  message(STATUS "CMAKE_QT_VERSION: ${CMAKE_QT_VERSION}")
else()
  set(CMAKE_QT_VERSION 6)
  message(STATUS "CMAKE_QT_VERSION: ${CMAKE_QT_VERSION}")
endif()

#set the resource compiler
if(CMAKE_AUTORCC)
  message(STATUS "CMAKE_AUTORCC: ${CMAKE_AUTORCC}")
else()
  set(CMAKE_AUTORCC ON)
  message(STATUS "CMAKE_AUTORCC: ${CMAKE_AUTORCC}")
endif()

find_package(
        Qt6 COMPONENTS
        Test
        Core
        Gui
        Sql
        Widgets
        REQUIRED
)

# check if the tests are enabled
if(CMAKE_TESTING_ENABLED)
  message(STATUS "Testing enabled")
else()
  if (CMAKE_BUILD_TYPE STREQUAL "Debug")
    set(CMAKE_TESTING_ENABLED on)
    if(NOT(CMAKE_TESTING_ENABLED))
      message(STATUS "Failed to enable testing")
    else()
      message(STATUS "Testing enabled")
        add_subdirectory(test)
    endif()
  else()
    message(
            STATUS
            "CMake is in '${CMAKE_BUILD_TYPE}' mode, testing is disabled."
    )
  endif()
endif()

add_executable(
        powa_bonk
        main.cpp
        resources/resources.qrc
        src/Login_window.hpp
        include/SQL_API.hpp
        include/Login_handler.hpp
        include/Users.hpp
        src/Dashboard.hpp
        include/statement.hpp
)

target_link_libraries(
        powa_bonk
        Qt::Core
        Qt::Gui
        Qt6::Sql
        Qt6::Test
        Qt::Widgets
)