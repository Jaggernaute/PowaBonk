cmake_minimum_required(VERSION 3.21)
project(mytest LANGUAGES CXX)

set(SKIP_AUTOMOC ON)

add_library(common INTERFACE)

if(CMAKE_QT_VERSION)
  message(STATUS "CMAKE_QT_VERSION: ${CMAKE_QT_VERSION}")
else()
  set(CMAKE_QT_VERSION Qt5)
endif()

find_package(${CMAKE_QT_VERSION}Test REQUIRED)

add_library(coverage_config INTERFACE)

find_package(
        ${CMAKE_QT_VERSION} COMPONENTS
        Test
        Core
        Gui
        Sql
        Widgets
        REQUIRED
)

# log if the package was found
if(${CMAKE_QT_VERSION}Test_FOUND)
  message(STATUS "${CMAKE_QT_VERSION}Test found")
else(${CMAKE_QT_VERSION}Test_FOUND)
  message(FATAL_ERROR "${CMAKE_QT_VERSION}Test not found")
endif(${CMAKE_QT_VERSION}Test_FOUND)

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOMOC ON)

include(CTest)
enable_testing(true)

add_executable(
        sql_tests
        sql_tests.hpp
        ../resources/resources.qrc
)
add_test(NAME sql_tests COMMAND sql_tests)
target_link_libraries(sql_tests PRIVATE ${CMAKE_QT_VERSION}::Test common Qt5::Sql)

add_executable(
        hash_tests
        hash_tests.hpp
        ../resources/resources.qrc
)
add_test(NAME hash_tests COMMAND hash_tests)
target_link_libraries(hash_tests PRIVATE ${CMAKE_QT_VERSION}::Test common)

add_executable(
        connection_tests
        connection_tests.hpp
        ../resources/resources.qrc
)
add_test(NAME connection_tests COMMAND connection_tests)
target_link_libraries(connection_tests PRIVATE ${CMAKE_QT_VERSION}::Test common)
