# - Try to find GTK and its components adn platforms
#
# Copyright (C) 2012 Raphael Kubo da Costa <rakuco@webkit.org>
# Copyright (C) 2018 Konstantin Pugin <ria.freelander@gmail.com>
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1.  Redistributions of source code must retain the above copyright
#     notice, this list of conditions and the following disclaimer.
# 2.  Redistributions in binary form must reproduce the above copyright
#     notice, this list of conditions and the following disclaimer in the
#     documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDER AND ITS CONTRIBUTORS ``AS
# IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
# THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR ITS
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
# OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
# OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


#defined components:
set(GTK_COMP_LIBRARIES GDK GTK UNIX_PRINT)
set(GTK_COMP_TOOLS BUILDER_TOOL ENCODE_SYMBOLIC_SVG)
set(GTK_COMP_PLATFORMS X11 BROADWAY WAYLAND)
set(GTK_VERSION_MAX_SUPPORTED 3)


INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE(PkgConfig QUIET)
if (${GTK_FIND_VERSION_MAJOR})
	set(_module_name GTK${GTK_FIND_VERSION_MAJOR})
	set(_version_num ${GTK_FIND_VERSION_MAJOR}.0)
	set(_version_short ${GTK_FIND_VERSION_MAJOR})
else()
	set(_module_name GTK${GTK_VERSION_MAX_SUPPORTED})
	set(_version_num ${GTK_VERSION_MAX_SUPPORTED}.0)
	set(_version_short ${GTK_VERSION_MAX_SUPPORTED})
endif()
PKG_CHECK_MODULES(PC_${_module_name} QUIET gtk+-${_version_num})

if(${_version_short} GREATER 2)
	set(_main_lib_name gtk-${_version_short})
else()
	set(_main_lib_name gtk-x11-${_version_num}) 
endif()

FIND_LIBRARY(${_module_name}_GTK_LIBRARY
    NAMES ${_main_lib_name}
    HINTS ${PC_${_module_name}_LIBDIR}
          ${PC_${_module_name}_LIBRARY_DIRS}
)

FIND_PATH(${_module_name}_GTK_INCLUDE
    NAMES gtk/gtk.h
    HINTS ${PC_${_module_name}_INCLUDEDIR}
          ${PC_${_module_name}_INCLUDE_DIRS}
    PATH_SUFFIXES gtk-${_version_num}
)

set(${_module_name}_GTK_VERSION ${PC_${_module_name}_VERSION})
SET(${_module_name}_VERSION "${${_module_name}_GTK_VERSION}")

find_package_handle_standard_args(${_module_name}_GTK
    REQUIRED_VARS
		${_module_name}_GTK_LIBRARY
        ${_module_name}_GTK_INCLUDE
    VERSION_VAR
        ${_module_name}_GTK_VERSION
    )

find_package_handle_standard_args(GTK_GTK
    REQUIRED_VARS
		${_module_name}_GTK_LIBRARY
        ${_module_name}_GTK_INCLUDE
    VERSION_VAR
        ${_module_name}_GTK_VERSION
    )

mark_as_advanced(
	${_module_name}_GTK_LIBRARY
    ${_module_name}_GTK_INCLUDE
)
if(${_module_name}_GTK_FOUND)
    list(APPEND ${_module_name}_LIBRARIES
                "${${_module_name}_GTK_LIBRARY}")
    list(APPEND ${_module_name}_INCLUDE_DIRS
                "${${_module_name}_GTK_INCLUDE}")
    set(${_module_name}_DEFINITIONS
            ${${_module_name}_DEFINITIONS}
            ${PC_${_module_name}_DEFINITIONS})
    if(NOT TARGET ${_module_name}::GTK)
        add_library(${_module_name}::GTK UNKNOWN IMPORTED)
        set_target_properties(${_module_name}::GTK PROPERTIES
            IMPORTED_LOCATION "${${_module_name}_GTK_LIBRARY}"
            INTERFACE_COMPILE_OPTIONS "${PC_${_module_name}_DEFINITIONS}"
            INTERFACE_INCLUDE_DIRECTORIES "${${_module_name}_GTK_INCLUDE}"
        )
    endif()
    list(APPEND ${_module_name}_TARGETS
                "${_module_name}::GTK")
endif()

if(GTK_FIND_COMPONENTS)
	set(_comp_iterator ${GTK_FIND_COMPONENTS})
else()
	set(_comp_iterator ${${_module_name}_FIND_COMPONENTS})
endif()

# Additional GTK components.
FOREACH (_component ${_comp_iterator})
	string(TOLOWER "${_component}" _lc_comp)
	string(REPLACE "_" "-" _rep_comp "${_lc_comp}")
    set(${_module_name}_${_component}_VERSION "${${_module_name}_VERSION}")
	list(APPEND _comp_deps "${_module_name}::GTK")
    list(APPEND _comp_dep_vars "${_module_name}_GTK_FOUND")
	set(_path_suffix gtk)
	if(_component IN_LIST GTK_COMP_LIBRARIES)
		set(_path_suffix gtk-${_version_num})
		set(_library_name gtk-${_version_short})
	    if (${_component} STREQUAL "UNIX_PRINT")
			PKG_CHECK_MODULES(PC_${_component} QUIET gtk+-${_rep_comp}-${_version_num})
			set(_comp_header gtk/gtkunixprint.h)
			set(_path_suffix gtk-${_version_num}/unix-print)
	    elseif (${_component} STREQUAL "GDK")
			PKG_CHECK_MODULES(PC_${_component} QUIET ${_rep_comp}-${_version_num})
			set(_comp_header gdk/gdk.h)
			if(${_version_short} GREATER 2)
				set(_library_name gdk-${_version_short})
			else()
				set(_library_name gdk-x11-${_version_num})
			endif()
		elseif (${_component} STREQUAL "GTK")
			continue()
		endif()
        find_path(${_module_name}_${_component}_INCLUDE_DIR
            NAMES ${_comp_header}
            HINTS ${PC_${_component}_INCLUDE_DIRS}
            PATH_SUFFIXES ${_path_suffix}
        )
        find_library(${_module_name}_${_component}_LIBRARY
            NAMES ${_library_name}
            HINTS ${PC_${_component}_LIBRARY_DIRS}
        )
        find_package_handle_standard_args(${_module_name}_${_component}
            REQUIRED_VARS
                ${_module_name}_${_component}_LIBRARY
                ${_module_name}_${_component}_INCLUDE_DIR
                ${_comp_dep_vars}
            VERSION_VAR
                ${_module_name}_${_component}_VERSION
            )
        find_package_handle_standard_args(GTK_${_component}
            REQUIRED_VARS
                ${_module_name}_${_component}_LIBRARY
                ${_module_name}_${_component}_INCLUDE_DIR
                ${_comp_dep_vars}
            VERSION_VAR
                ${_module_name}_${_component}_VERSION
            )
        mark_as_advanced(
            ${_module_name}_${_component}_LIBRARY
            ${_module_name}_${_component}_INCLUDE_DIR
        )
        if(${_module_name}_${_component}_FOUND)
            list(APPEND ${_module_name}_LIBRARIES
                        "${${_module_name}_${_component}_LIBRARY}")
            list(APPEND ${_module_name}_INCLUDE_DIRS
                        "${${_module_name}_${_component}_INCLUDE_DIR}")
            set(${_module_name}_DEFINITIONS
                    ${${_module_name}_DEFINITIONS}
                    ${PC_${_component}_DEFINITIONS})
            if(NOT TARGET ${_module_name}::${_component})
                add_library(${_module_name}::${_component} UNKNOWN IMPORTED)
                set_target_properties(${_module_name}::${_component} PROPERTIES
                    IMPORTED_LOCATION "${${_module_name}_${_component}_LIBRARY}"
                    INTERFACE_COMPILE_OPTIONS "${PC_${_component}_DEFINITIONS}"
                    INTERFACE_INCLUDE_DIRECTORIES "${${_module_name}_${_component}_INCLUDE_DIR}"
                    INTERFACE_LINK_LIBRARIES "${_comp_deps}"
                )
            endif()
            list(APPEND ${_module_name}_TARGETS
                        "${_module_name}::${_component}")
		endif()
	elseif(_component IN_LIST GTK_COMP_TOOLS)
		set(_program_name gtk-${_rep_comp})
		find_program(${_module_name}_${_component}_EXECUTABLE
			${_program_name}
		)
        find_package_handle_standard_args(${_module_name}_${_component}
            REQUIRED_VARS
                ${_module_name}_${_component}_EXECUTABLE
            VERSION_VAR
                ${_module_name}_${_component}_VERSION
            )
        find_package_handle_standard_args(GTK_${_component}
            REQUIRED_VARS
                ${_module_name}_${_component}_EXECUTABLE
            VERSION_VAR
                ${_module_name}_${_component}_VERSION
            )
        mark_as_advanced(
            ${_module_name}_${_component}_EXECUTABLE
        )
        if(${_module_name}_${_component}_FOUND)
            if(NOT TARGET ${_module_name}::${_component})
                add_executable(${_module_name}::${_component} IMPORTED)
            endif()
            list(APPEND ${_module_name}_TARGETS
                        "${_module_name}::${_component}")
		endif()
	elseif(_component IN_LIST GTK_COMP_PLATFORMS)
		if (${_component} STREQUAL "X11")
			set(_comp_header gdk/gdkx.h)
		elseif(${_component} STREQUAL "BROADWAY")
			set(_comp_header gdk/gdkbroadway.h)
		else()
			set(_comp_header gdk/gdkwayland.h)
		endif()
        find_path(${_module_name}_${_component}_INCLUDE_DIR
            NAMES ${_comp_header}
			HINTS ${PC_${_module_name}_INCLUDEDIR}
				  ${PC_${_module_name}_INCLUDE_DIRS}
			PATH_SUFFIXES gdk
        )
		if(${_component} STREQUAL "BROADWAY")
			find_program(${_module_name}_${_component}D_EXECUTABLE
				${_rep_comp}d
			)
		    find_package_handle_standard_args(${_module_name}_${_component}
		        REQUIRED_VARS
		            ${_module_name}_${_component}_INCLUDE_DIR
					${_module_name}_${_component}D_EXECUTABLE
		        VERSION_VAR
		            ${_module_name}_${_component}_VERSION
            )
		    find_package_handle_standard_args(GTK_${_component}
		        REQUIRED_VARS
		            ${_module_name}_${_component}_INCLUDE_DIR
					${_module_name}_${_component}D_EXECUTABLE
		        VERSION_VAR
		            ${_module_name}_${_component}_VERSION
            )
		    mark_as_advanced(
		        ${_module_name}_${_component}D_EXECUTABLE
		    )
		    if(${_module_name}_${_component}_FOUND)
		        if(NOT TARGET ${_module_name}::${_component}D)
		            add_executable(${_module_name}::${_component}D IMPORTED)
		        endif()
		        list(APPEND ${_module_name}_TARGETS
		                    "${_module_name}::${_component}D")
			endif()
		else()
        find_package_handle_standard_args(${_module_name}_${_component}
            REQUIRED_VARS
                ${_module_name}_${_component}_INCLUDE_DIR
            VERSION_VAR
                ${_module_name}_${_component}_VERSION
            )
        find_package_handle_standard_args(GTK_${_component}
            REQUIRED_VARS
                ${_module_name}_${_component}_INCLUDE_DIR
            VERSION_VAR
                ${_module_name}_${_component}_VERSION
            )
		endif()
        mark_as_advanced(
            ${_module_name}_${_component}_INCLUDE_DIR
        )
        if(${_module_name}_${_component}_FOUND)
            if(NOT TARGET ${_module_name}::${_component})
                add_library(${_module_name}::${_component} UNKNOWN IMPORTED)
                set_target_properties(${_module_name}::${_component} PROPERTIES
                    INTERFACE_LINK_LIBRARIES ${_module_name}::GTK 
                )
            endif()
            list(APPEND ${_module_name}_TARGETS
                        "${_module_name}::${_component}")
		endif()
	endif()
ENDFOREACH ()

FIND_PACKAGE_HANDLE_STANDARD_ARGS(${_module_name}
    REQUIRED_VARS
        ${_module_name}_LIBRARIES
        ${_module_name}_INCLUDE_DIRS
    HANDLE_COMPONENTS
    VERSION_VAR
        ${_module_name}_VERSION)

FIND_PACKAGE_HANDLE_STANDARD_ARGS(GTK
    REQUIRED_VARS
        ${_module_name}_LIBRARIES
        ${_module_name}_INCLUDE_DIRS
	HANDLE_COMPONENTS
    VERSION_VAR
        ${_module_name}_VERSION)

if(${_module_name}_LIBRARIES)
    list(REMOVE_DUPLICATES ${_module_name}_LIBRARIES)
endif()
if(${_module_name}_INCLUDE_DIRS)
    list(REMOVE_DUPLICATES ${_module_name}_INCLUDE_DIRS)
endif()
if(${_module_name}_DEFINITIONS)
    list(REMOVE_DUPLICATES ${_module_name}_DEFINITIONS)
endif()
if(${_module_name}_TARGETS)
    list(REMOVE_DUPLICATES ${_module_name}_TARGETS)
endif()
