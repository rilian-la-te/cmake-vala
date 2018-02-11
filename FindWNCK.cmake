# FindWNCK.cmake, CMake macros written for ValaPanel, feel free to re-use them

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
