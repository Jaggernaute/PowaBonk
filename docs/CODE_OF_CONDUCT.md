# Code of Conduct

Everyone that interacts with the PowaBonk project is expected to follow those guidelines:
1. Use the [CMake](https://cmake.org) build system.
2. Follow the LLVM cpp [style guide](https://clang.llvm.org/docs/index.html).
3. Try to avoid CLang tidy warnings (some rules contradicts each others so try to avoid them but use some common sense).
4. try to avoid using [Qt's](https://www.qt-project.org/) non-standard features.
5. 5. use c++23 or higher(when it'll be released).
6. please respect the architecture of the project :
    ```
    .
    |--include
    |--libs
    |--ressources
    |  |--css
    |  |--images
    |  `--.env
    |--src
    `--tests
    ```


And in general, everyone is expected to be **open**,
**considerate**, and **respectful** of others no matter what their position is
within the project.