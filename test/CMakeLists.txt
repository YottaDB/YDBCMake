# This is free and unencumbered software released into the public domain.
#
# Anyone is free to copy, modify, publish, use, compile, sell, or
# distribute this software, either in source code form or as a compiled
# binary, for any purpose, commercial or non-commercial, and by any
# means.
#
# In jurisdictions that recognize copyright laws, the author or authors
# of this software dedicate any and all copyright interest in the
# software to the public domain. We make this dedication for the benefit
# of the public at large and to the detriment of our heirs and
# successors. We intend this dedication to be an overt act of
# relinquishment in perpetuity of all present and future rights to this
# software under copyright law.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
# OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.
#
# For more information, please refer to <http://unlicense.org/>

# Use 3.14 for support for FetchContent_Declare/FetchContent_MakeAvailable
cmake_minimum_required(VERSION 3.14)
include(FetchContent)

# In a production use, use GIT_REPOSITORY and GIT_TAG
# We use SOURCE_DIR because this is the same repo
FetchContent_Declare(YDBCMake
	#GIT_REPOSITORY	https://gitlab.com/YottaDB/Tools/YDBCMake.git
	#GIT_TAG	84c5180d1f184a892f5cc52367ce51f9bc2eac7e
	SOURCE_DIR      ${CMAKE_CURRENT_SOURCE_DIR}/../
)
FetchContent_MakeAvailable(YDBCMake)
message(STATUS "YDBCMake Source Directory: ${ydbcmake_SOURCE_DIR}")
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${ydbcmake_SOURCE_DIR}/ydbcmake/")

project(YDBCMakeTest M)

# Find YottaDB and get Install Destination
find_package(YOTTADB REQUIRED)
message(STATUS "Install Location: ${YOTTADB_PLUGIN_PREFIX}")

# Add library
add_ydb_library(testCMake SOURCES test1.m test2.m)

# Install library
install_ydb_library(testCMake)

# Optionally, install the sources. This does nothing at runtime, as the sources are not used at all.
install_ydb_sources(SOURCES test1.m test2.m)
