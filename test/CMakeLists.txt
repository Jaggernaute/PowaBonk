project(mytest LANGUAGES CXX)

set(SKIP_AUTOMOC ON)

find_package(Qt6Test REQUIRED)

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