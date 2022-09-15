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

set(CMAKE_M_CREATE_SHARED_LIBRARY "${CC} -shared -o <TARGET> <OBJECTS>")
set(CMAKE_M_CREATE_SHARED_MODULE "${CC} -shared -o <TARGET> <OBJECTS>")
set(CMAKE_M_CREATE_STATIC_LIBRARY "")

# Option to suppress mumps compiler warnings
option(M_NOWARNING "Disable warnings and ignore status code from M compiler")
option(M_EMBED_SOURCE "Embed source code in generated shared object" ON)
option(M_DYNAMIC_LITERALS "Enable dynamic loading of source code literals" OFF)
option(M_NOLINE_ENTRY "Compile M code without access to label offsets" OFF)

set(CMAKE_M_COMPILE_OBJECT "LC_ALL=${LC_ALL} <FLAGS> <CMAKE_M_COMPILER> -object=<OBJECT>")

if(M_EMBED_SOURCE)
  set(CMAKE_M_COMPILE_OBJECT "${CMAKE_M_COMPILE_OBJECT} -embed_source")
endif()

if(M_DYNAMIC_LITERALS)
  set(CMAKE_M_COMPILE_OBJECT "${CMAKE_M_COMPILE_OBJECT} -dynamic_literals")
endif()

if(M_NOLINE_ENTRY)
  set (CMAKE_M_COMPILE_OBJECT "${CMAKE_M_COMPILE_OBJECT} -noline_entry")
endif()

if(M_NOWARNING)
  set(CMAKE_M_COMPILE_OBJECT "${CMAKE_M_COMPILE_OBJECT} -nowarning <SOURCE> || true")
else()
  set(CMAKE_M_COMPILE_OBJECT "${CMAKE_M_COMPILE_OBJECT} <SOURCE>")
endif()

set(CMAKE_M_LINK_EXECUTABLE "")

set(CMAKE_M_OUTPUT_EXTENSION .o)

# See https://jeremimucha.com/2021/02/cmake-functions-and-macros/ for how to parse SOURCES
function(add_ydb_library library_name)
	set(flags)
	set(args)
	set(listArgs SOURCES)
	cmake_parse_arguments(arg "${flags}" "${args}" "${listArgs}" ${ARGN})

	if (NOT arg_SOURCES)
		message(FATAL_ERROR "[add_ydb_library]: SOURCES is a required argument")
	endif()
	if (SOURCES IN_LIST arg_KEYWORDS_MISSING_VALUES)
		message(FATAL_ERROR "[add_ydb_library]: SOURCES requires at least one value")
	endif()
	add_library(${library_name}M SHARED ${arg_SOURCES})
	target_compile_options(${library_name}M PRIVATE ydb_chset=M ydb_icu_version=) 
	set_target_properties(${library_name}M PROPERTIES PREFIX "")
	set_target_properties(${library_name}M PROPERTIES LIBRARY_OUTPUT_NAME ${library_name})
	set_target_properties(${library_name}M PROPERTIES LIBRARY_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR})
	if(ydb_icu_version)
		add_library(${library_name}utf8 SHARED ${arg_SOURCES})
		target_compile_options(${library_name}utf8 PRIVATE ydb_chset=utf-8 ydb_icu_version=${ydb_icu_version}) 
		set_target_properties(${library_name}utf8 PROPERTIES PREFIX "")
		set_target_properties(${library_name}utf8 PROPERTIES LIBRARY_OUTPUT_NAME ${library_name})
		set_target_properties(${library_name}utf8 PROPERTIES LIBRARY_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/utf8)
	endif()
endfunction()

function(install_ydb_sources)
	set(flags)
	set(args)
	set(listArgs SOURCES)
	cmake_parse_arguments(arg "${flags}" "${args}" "${listArgs}" ${ARGN})

	if (NOT arg_SOURCES)
		message(FATAL_ERROR "[install_ydb_sources]: SOURCES is a required argument")
	endif()
	if (SOURCES IN_LIST arg_KEYWORDS_MISSING_VALUES)
		message(FATAL_ERROR "[install_ydb_sources]: SOURCES requires at least one value")
	endif()

	install(FILES ${arg_SOURCES} DESTINATION ${YOTTADB_PLUGIN_PREFIX}/r/)
endfunction()

function(install_ydb_library library_name)
	install(TARGETS ${library_name}M DESTINATION ${YOTTADB_M_PLUGIN_DIR})
	if(ydb_icu_version)
		install(TARGETS ${library_name}utf8 DESTINATION ${YOTTADB_M_PLUGIN_DIR}/utf8)
	endif()
endfunction()
