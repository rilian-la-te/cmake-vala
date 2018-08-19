# FindWNCK.cmake, Finds libwnck
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

INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE(PkgConfig QUIET)

set(WNCK_VERSION_MAX_SUPPORTED 3)

if (${WNCK_FIND_VERSION_MAJOR})
	set(_version_num ${WNCK_FIND_VERSION_MAJOR}.0)
	set(_version_short ${WNCK_FIND_VERSION_MAJOR})
else()
	set(_version_num ${WNCK_VERSION_MAX_SUPPORTED}.0)
	set(_version_short ${WNCK_VERSION_MAX_SUPPORTED})
endif()
PKG_CHECK_MODULES(PC_WNCK QUIET libwnck-${_version_num})

FIND_LIBRARY(WNCK_LIBRARY
    NAMES wnck-${_version_short}
    HINTS ${PC_WNCK_LIBDIR}
          ${PC_WNCK_LIBRARY_DIRS}
)

FIND_PATH(WNCK_INCLUDE
    NAMES libwnck/version.h
    HINTS ${PC_WNCK_INCLUDEDIR}
          ${PC_WNCK_INCLUDE_DIRS}
    PATH_SUFFIXES libwnck-${_version_num}
)

set(WNCK_VERSION ${PC_WNCK_VERSION})
set(WNCK_INCLUDE_DIRS ${WNCK_INCLUDE})

find_package_handle_standard_args(WNCK
    REQUIRED_VARS
		WNCK_LIBRARY
        WNCK_INCLUDE
    VERSION_VAR
        WNCK_VERSION
    )

mark_as_advanced(
	WNCK_LIBRARY
    WNCK_INCLUDE
)
if(WNCK_FOUND)
    set(WNCK_DEFINITIONS
            ${WNCK_DEFINITIONS}
            ${PC_WNCK_DEFINITIONS}
			-DWNCK_I_KNOW_THIS_IS_UNSTABLE
		)
    if(NOT TARGET WNCK::WNCK)
        add_library(WNCK::WNCK UNKNOWN IMPORTED)
        set_target_properties(WNCK::WNCK PROPERTIES
            IMPORTED_LOCATION "${WNCK_LIBRARY}"
            INTERFACE_COMPILE_OPTIONS "${WNCK_DEFINITIONS}"
            INTERFACE_INCLUDE_DIRECTORIES "${WNCK_INCLUDE}"
        )
    endif()
endif()
