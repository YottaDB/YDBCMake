# YDBCMake
This repository contains CMake scripts for YottaDB to compile and install
YottaDB plugins.

# License
Except for pipeline scripts, no claim of copyright is made with respect to code
in this repository and it is released under the terms of the Unlicense. The
pipeline scripts are Copyright YottaDB LLC, and are licensed under the terms of
AGPL v3.

# Instructions for Usage for M Plugins
Typical usage involves using the following steps (see a full example
[here](test/CMakeLists.txt)):

- Set `cmake_minimum_required` to 3.14.
- Include `FetchContent`
- Declare/Fetch YDBCMake using a git repo/hash (update hash as needed to keep up with
  newer versions)
- Add `${ydbcmake_SOURCE_DIR}/ydbcmake/` to the source path
- Set-up your project as language `M`
- Find YottaDB using `find_package`
- Create library using `add_ydb_library()`
- Install library using `install_ydb_library()`
- Install sources using `install_ydb_sources()`

# Instructions for Usage for C Plugins
No full example for this right now.

- Set `cmake_minimum_required` to 3.14.
- Include `FetchContent`
- Declare/Fetch YDBCMake using a git repo/hash (update hash as needed to keep up with
  newer versions)
- Add `${ydbcmake_SOURCE_DIR}/ydbcmake/` to the source path
- Set-up your project as language `C`
- Find YottaDB using `find_package`
- Create library using the native CMake `add_library`
- Add the includes on the library as `YOTTADB_INCLUDE_DIRS` using `target_include_directories()`.
- Install into `YOTTADB_C_PLUGIN_DIR` using `install()`.

# Limitations
- The package currently does not support adding tests. Testing could be done
  with a macro that adds M and UTF-8 mode tests.
- Call-in/Call-out files need support; none right now.
- C Plug-in support can be better (add macro/function to support `${YOTTADB_INCLUDE_DIRS}`,
  and add macro/function to support install directly into `${YOTTADB_C_PLUGIN_DIR}`.

# Advanced Usage Notes
* Our plugins use FetchContent to download the repo dynamically from Gitlab. You
  can use a local copy of this repository (e.g., when you are making changes and
  need to add features to test them out) by passing the CMake cache variable
  `FETCHCONTENT_SOURCE_DIR_YDBCMAKE`; for example, `-D
  FETCHCONTENT_SOURCE_DIR_YDBCMAKE:PATH=/home/user/work/gitlab/YDBCMake`.
* To debug the code, use `cmake --trace`, and `make VERBOSE=1`. Tracing cmake
  is a lot of output, so you would usually combine stdout and stdin and grep
  the combined output for a pattern, e.g. `ydbcmake`.
