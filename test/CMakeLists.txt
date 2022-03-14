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

add_executable(test_main test_main.hpp)
add_test(NAME test_main COMMAND test_main)

target_link_libraries(test_main PRIVATE Qt6::Test)