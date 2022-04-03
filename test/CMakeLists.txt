project(mytest LANGUAGES CXX)

set(SKIP_AUTOMOC ON)

find_package(Qt6Test REQUIRED)

add_library(coverage_config INTERFACE)

option(CODE_COVERAGE "Enable coverage reporting" ON)
if(CODE_COVERAGE AND CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang")
    # Add required flags (GCC & LLVM/Clang)
    target_compile_options(coverage_config INTERFACE
            -O0        # no optimization
            -g         # generate debug info
            --coverage # sets all required flags
            )
    if(CMAKE_VERSION VERSION_GREATER_EQUAL 3.13)
        target_link_options(coverage_config INTERFACE --coverage)
    else()
        target_link_libraries(coverage_config INTERFACE --coverage)
    endif()
endif(CODE_COVERAGE AND CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang")

# log if the package was found
if(Qt6Test_FOUND)
  message(STATUS "Qt6Test found")
else(Qt6Test_FOUND)
  message(FATAL_ERROR "Qt6Test not found")
endif(Qt6Test_FOUND)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOMOC ON)

enable_testing(true)

add_executable(
        sql_tests
        sql_tests.hpp
        ../resources/resources.qrc
)
add_test(NAME sql_tests COMMAND sql_tests)
target_link_libraries(sql_tests PRIVATE Qt6::Test)

add_executable(
        hash_tests
        hash_tests.hpp
        ../resources/resources.qrc
)
add_test(NAME hash_tests COMMAND hash_tests)
target_link_libraries(hash_tests PRIVATE Qt6::Test)

add_executable(
        connection_tests
        connection_tests.hpp
        ../resources/resources.qrc
)
add_test(NAME connection_tests COMMAND connection_tests)
target_link_libraries(connection_tests PRIVATE Qt6::Test)