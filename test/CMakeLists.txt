cmake_minimum_required(VERSION 3.21)
project(mytest LANGUAGES CXX)

set(SKIP_AUTOMOC ON)

add_library(common INTERFACE)

find_package(Qt6Test REQUIRED)

add_library(coverage_config INTERFACE)

# log if the package was found
if(Qt6Test_FOUND)
  message(STATUS "Qt6Test found")
else(Qt6Test_FOUND)
  message(FATAL_ERROR "Qt6Test not found")
endif(Qt6Test_FOUND)

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
target_link_libraries(sql_tests PRIVATE Qt6::Test common)

add_executable(
        hash_tests
        hash_tests.hpp
        ../resources/resources.qrc
)
add_test(NAME hash_tests COMMAND hash_tests)
target_link_libraries(hash_tests PRIVATE Qt6::Test common)

add_executable(
        connection_tests
        connection_tests.hpp
        ../resources/resources.qrc
)
add_test(NAME connection_tests COMMAND connection_tests)
target_link_libraries(connection_tests PRIVATE Qt6::Test common)
