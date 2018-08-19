# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

#.rst:
# FindX11
# -------
#
# Find X11 installation
#
# Try to find X11 on UNIX systems. The following values are defined
#
# ::
#
#   X11_FOUND        - True if X11 is available
#   X11_INCLUDE_DIR  - include directories to use X11
#   X11_LIBRARIES    - link against these to use X11
#
# and also the following more fine grained variables:
#
# ::
#
#   X11_ICE_INCLUDE_PATH,          X11_ICE_LIB,        X11_ICE_FOUND
#   X11_SM_INCLUDE_PATH,           X11_SM_LIB,         X11_SM_FOUND
#   X11_X11_INCLUDE_PATH,          X11_X11_LIB
#   X11_Xaccessrules_INCLUDE_PATH,                     X11_Xaccess_FOUND
#   X11_Xaccessstr_INCLUDE_PATH,                       X11_Xaccess_FOUND
#   X11_Xau_INCLUDE_PATH,          X11_Xau_LIB,        X11_Xau_FOUND
#   X11_Xcomposite_INCLUDE_PATH,   X11_Xcomposite_LIB, X11_Xcomposite_FOUND
#   X11_Xcursor_INCLUDE_PATH,      X11_Xcursor_LIB,    X11_Xcursor_FOUND
#   X11_Xdamage_INCLUDE_PATH,      X11_Xdamage_LIB,    X11_Xdamage_FOUND
#   X11_Xdmcp_INCLUDE_PATH,        X11_Xdmcp_LIB,      X11_Xdmcp_FOUND
#   X11_Xext_LIB,       X11_Xext_FOUND
#   X11_dpms_INCLUDE_PATH,         (in X11_Xext_LIB),  X11_dpms_FOUND
#   X11_XShm_INCLUDE_PATH,         (in X11_Xext_LIB),  X11_XShm_FOUND
#   X11_Xshape_INCLUDE_PATH,       (in X11_Xext_LIB),  X11_Xshape_FOUND
#   X11_xf86misc_INCLUDE_PATH,     X11_Xxf86misc_LIB,  X11_xf86misc_FOUND
#   X11_xf86vmode_INCLUDE_PATH,    X11_Xxf86vm_LIB     X11_xf86vmode_FOUND
#   X11_Xfixes_INCLUDE_PATH,       X11_Xfixes_LIB,     X11_Xfixes_FOUND
#   X11_Xft_INCLUDE_PATH,          X11_Xft_LIB,        X11_Xft_FOUND
#   X11_Xi_INCLUDE_PATH,           X11_Xi_LIB,         X11_Xi_FOUND
#   X11_Xinerama_INCLUDE_PATH,     X11_Xinerama_LIB,   X11_Xinerama_FOUND
#   X11_Xinput_INCLUDE_PATH,       X11_Xinput_LIB,     X11_Xinput_FOUND
#   X11_Xkb_INCLUDE_PATH,                              X11_Xkb_FOUND
#   X11_Xkblib_INCLUDE_PATH,                           X11_Xkb_FOUND
#   X11_Xkbfile_INCLUDE_PATH,      X11_Xkbfile_LIB,    X11_Xkbfile_FOUND
#   X11_Xmu_INCLUDE_PATH,          X11_Xmu_LIB,        X11_Xmu_FOUND
#   X11_Xpm_INCLUDE_PATH,          X11_Xpm_LIB,        X11_Xpm_FOUND
#   X11_XTest_INCLUDE_PATH,        X11_XTest_LIB,      X11_XTest_FOUND
#   X11_Xrandr_INCLUDE_PATH,       X11_Xrandr_LIB,     X11_Xrandr_FOUND
#   X11_Xrender_INCLUDE_PATH,      X11_Xrender_LIB,    X11_Xrender_FOUND
#   X11_Xscreensaver_INCLUDE_PATH, X11_Xscreensaver_LIB, X11_Xscreensaver_FOUND
#   X11_Xt_INCLUDE_PATH,           X11_Xt_LIB,         X11_Xt_FOUND
#   X11_Xutil_INCLUDE_PATH,                            X11_Xutil_FOUND
#   X11_Xv_INCLUDE_PATH,           X11_Xv_LIB,         X11_Xv_FOUND
#   X11_XSync_INCLUDE_PATH,        (in X11_Xext_LIB),  X11_XSync_FOUND

#components list:
# ICE SM Xaccess Xauth Xcomposite XCursor XDamage Xdmcp dpms
# xf86misc xf86vmode Xfixes Xft XInput Xkblib Xkbfile Xmu Xpm
# Xscreensaver Xshape XShm Xt XTest Xv Xsync

if (UNIX)
  set(X11_FOUND 0)
  # X11 is never a framework and some header files may be
  # found in tcl on the mac
  set(CMAKE_FIND_FRAMEWORK_SAVE ${CMAKE_FIND_FRAMEWORK})
  set(CMAKE_FIND_FRAMEWORK NEVER)
  set(X11_INC_SEARCH_PATH
    /usr/pkg/xorg/include
    /usr/X11R6/include
    /usr/X11R7/include
    /usr/include/X11
    /usr/openwin/include
    /usr/openwin/share/include
    /opt/graphics/OpenGL/include
    /opt/X11/include
  )

  set(X11_LIB_SEARCH_PATH
    /usr/pkg/xorg/lib
    /usr/X11R6/lib
    /usr/X11R7/lib
    /usr/openwin/lib
    /opt/X11/lib
  )

  find_path(X11_X11_INCLUDE_PATH X11/X.h                             ${X11_INC_SEARCH_PATH})
  find_path(X11_Xlib_INCLUDE_PATH X11/Xlib.h                         ${X11_INC_SEARCH_PATH})
  find_path(X11_Xutil_INCLUDE_PATH X11/Xutil.h                       ${X11_INC_SEARCH_PATH})

  # Solaris lacks XKBrules.h, so we should skip kxkbd there. Is this relevant for modern Solaris?


find_library(X11_X11_LIB X11               ${X11_LIB_SEARCH_PATH})
get_filename_component(X11_REALPATH ${X11_X11_LIB} REALPATH)
get_filename_component(X11_SO_VERSION ${X11_REALPATH} EXT)
string(SUBSTRING ${X11_SO_VERSION} 4 -1 X11_VERSION)
set(X11_X11_VERSION ${X11_VERSION})
find_package_handle_standard_args(X11_X11
    REQUIRED_VARS
        X11_X11_LIB
        X11_X11_INCLUDE_PATH
		X11_Xlib_INCLUDE_PATH
		X11_Xutil_INCLUDE_PATH
    VERSION_VAR
        X11_X11_VERSION
    )
mark_as_advanced(
    X11_X11_LIB
    X11_X11_INCLUDE_PATH
	X11_Xlib_INCLUDE_PATH
	X11_Xutil_INCLUDE_PATH
)
set(X11_X11_INCLUDE_DIR "${X11_X11_INCLUDE_PATH}" "${X11_Xlib_INCLUDE_PATH}" "${X11_Xutil_INCLUDE_PATH}")
if(X11_X11_FOUND)
    include(CheckFunctionExists)
    include(CheckLibraryExists)

    # Translated from an autoconf-generated configure script.
    # See libs.m4 in autoconf's m4 directory.
    if($ENV{ISC} MATCHES "^yes$")
      set(X11_X_EXTRA_LIBS -lnsl_s -linet)
    else()
      set(X11_X_EXTRA_LIBS "")

      # See if XOpenDisplay in X11 works by itself.
      CHECK_LIBRARY_EXISTS("${X11_LIBRARIES}" "XOpenDisplay" "${X11_LIBRARY_DIR}" X11_LIB_X11_SOLO)
      if(NOT X11_LIB_X11_SOLO)
        # Find library needed for dnet_ntoa.
        CHECK_LIBRARY_EXISTS("dnet" "dnet_ntoa" "" X11_LIB_DNET_HAS_DNET_NTOA)
        if (X11_LIB_DNET_HAS_DNET_NTOA)
          set (X11_X_EXTRA_LIBS ${X11_X_EXTRA_LIBS} -ldnet)
        else ()
          CHECK_LIBRARY_EXISTS("dnet_stub" "dnet_ntoa" "" X11_LIB_DNET_STUB_HAS_DNET_NTOA)
          if (X11_LIB_DNET_STUB_HAS_DNET_NTOA)
            set (X11_X_EXTRA_LIBS ${X11_X_EXTRA_LIBS} -ldnet_stub)
          endif ()
        endif ()
      endif()

      # Find library needed for gethostbyname.
      CHECK_FUNCTION_EXISTS("gethostbyname" CMAKE_HAVE_GETHOSTBYNAME)
      if(NOT CMAKE_HAVE_GETHOSTBYNAME)
        CHECK_LIBRARY_EXISTS("nsl" "gethostbyname" "" CMAKE_LIB_NSL_HAS_GETHOSTBYNAME)
        if (CMAKE_LIB_NSL_HAS_GETHOSTBYNAME)
          set (X11_X_EXTRA_LIBS ${X11_X_EXTRA_LIBS} -lnsl)
        else ()
          CHECK_LIBRARY_EXISTS("bsd" "gethostbyname" "" CMAKE_LIB_BSD_HAS_GETHOSTBYNAME)
          if (CMAKE_LIB_BSD_HAS_GETHOSTBYNAME)
            set (X11_X_EXTRA_LIBS ${X11_X_EXTRA_LIBS} -lbsd)
          endif ()
        endif ()
      endif()

      # Find library needed for connect.
      CHECK_FUNCTION_EXISTS("connect" CMAKE_HAVE_CONNECT)
      if(NOT CMAKE_HAVE_CONNECT)
        CHECK_LIBRARY_EXISTS("socket" "connect" "" CMAKE_LIB_SOCKET_HAS_CONNECT)
        if (CMAKE_LIB_SOCKET_HAS_CONNECT)
          set (X11_X_EXTRA_LIBS -lsocket ${X11_X_EXTRA_LIBS})
        endif ()
      endif()

      # Find library needed for remove.
      CHECK_FUNCTION_EXISTS("remove" CMAKE_HAVE_REMOVE)
      if(NOT CMAKE_HAVE_REMOVE)
        CHECK_LIBRARY_EXISTS("posix" "remove" "" CMAKE_LIB_POSIX_HAS_REMOVE)
        if (CMAKE_LIB_POSIX_HAS_REMOVE)
          set (X11_X_EXTRA_LIBS ${X11_X_EXTRA_LIBS} -lposix)
        endif ()
      endif()

      # Find library needed for shmat.
      CHECK_FUNCTION_EXISTS("shmat" CMAKE_HAVE_SHMAT)
      if(NOT CMAKE_HAVE_SHMAT)
        CHECK_LIBRARY_EXISTS("ipc" "shmat" "" CMAKE_LIB_IPS_HAS_SHMAT)
        if (CMAKE_LIB_IPS_HAS_SHMAT)
          set (X11_X_EXTRA_LIBS ${X11_X_EXTRA_LIBS} -lipc)
        endif ()
      endif()
    endif()
    list(APPEND X11_LIBRARIES
                "${X11_X11_LIB}")
    list(APPEND X11_INCLUDE_DIR
                "${X11_X11_INCLUDE_PATH}"
				"${X11_Xlib_INCLUDE_PATH}"
				"${X11_Xutil_INCLUDE_PATH}")
    if(NOT TARGET X11::X11)
        add_library(X11::X11 UNKNOWN IMPORTED)
        set_target_properties(X11::X11 PROPERTIES
            IMPORTED_LOCATION "${X11_X11_LIB}"
            INTERFACE_INCLUDE_DIRECTORIES "${X11_X11_INCLUDE_DIR}"
            INTERFACE_COMPILE_OPTIONS "${X11_X_EXTRA_LIBS}"
        )
    endif()
    list(APPEND X11_TARGETS
                "X11::X11")

  endif ()

# All X11 components.
FOREACH (_component ${X11_FIND_COMPONENTS})
	string(TOLOWER "${_component}" _lc_comp)
    set(X11_${_component}_VERSION "${X11_VERSION}")
	list(APPEND _comp_deps "X11::X11")
    list(APPEND _comp_dep_vars "X11_X11_FOUND")
	if (${_component} STREQUAL "Xaccess")
		set(_comp_header XKBstr.h)
		set(_library_name Xext)
    elseif (${_component} STREQUAL "Xauth")
		set(_library_name Xau)
	elseif (${_component} STREQUAL "dpms")
		set(_library_name Xext)
	elseif (${_component} STREQUAL "xf86vmode")
		set(_library_name Xxf86vm)
	elseif (${_component} STREQUAL "XInput")
		set(_library_name Xi)
	elseif (${_component} STREQUAL "Xkb")
		set(_comp_header XKB.h)
		set(_library_name Xext)
	elseif (${_component} STREQUAL "Xkblib")
		list(APPEND _comp_deps "X11::Xaccess")
        list(APPEND _comp_dep_vars "X11_Xaccess_FOUND")
		set(_comp_header XKBlib.h)
		set(_library_name Xext)
	elseif (${_component} STREQUAL "Xkbfile")
		set(_comp_header XKBfile.h)
	elseif (${_component} STREQUAL "Xscreensaver")
		set(_comp_header scrnsaver.h)
		set(_library_name Xss)
	elseif (${_component} STREQUAL "Xshape")
		set(_comp_header shape.h)
		set(_library_name Xext)
	elseif (${_component} STREQUAL "XShm")
		set(_library_name Xext)
	elseif (${_component} STREQUAL "Xt")
		set(_comp_header Intrinsic.h)
	elseif (${_component} STREQUAL "XTest")
		set(_library_name Xtst)
	elseif (${_component} STREQUAL "Xv")
		set(_comp_header Xvlib.h)
	elseif (${_component} STREQUAL "Xsync")
		set(_comp_header sync.h)
	elseif (${_component} STREQUAL "X11")
		continue()
	endif()
    find_path(X11_${_component}_INCLUDE_PATH
        NAMES ${_comp_header} ${_component}.h ${_lc_comp}.h
        HINTS ${X11_INC_SEARCH_PATH}
		PATH_SUFFIXES X11 X11/extensions X11/${_component}
    )
    find_library(X11_${_component}_LIB
        NAMES ${_library_name} ${_component} ${_lc_comp} X${_component}
        HINTS ${X11_LIB_SEARCH_PATH}
    )
    find_package_handle_standard_args(X11_${_component}
        REQUIRED_VARS
            X11_${_component}_LIB
            X11_${_component}_INCLUDE_PATH
            ${_comp_dep_vars}
        VERSION_VAR
            X11_${_component}_VERSION
        )
    mark_as_advanced(
        X11_${_component}_LIB
        X11_${_component}_INCLUDE_PATH
    )
    if(X11_${_component}_FOUND)
        list(APPEND X11_LIBRARIES
                    "${X11_${_component}_LIB}")
        list(APPEND X11_INCLUDE_DIR
                    "${X11_${_component}_INCLUDE_PATH}")
        if(NOT TARGET X11::${_component})
            add_library(X11::${_component} UNKNOWN IMPORTED)
            set_target_properties(X11::${_component} PROPERTIES
                IMPORTED_LOCATION "${X11_${_component}_LIB}"
                INTERFACE_INCLUDE_DIRECTORIES "${X11_${_component}_INCLUDE_PATH}"
                INTERFACE_LINK_LIBRARIES "${_comp_deps}"
            )
        endif()
        list(APPEND X11_TARGETS
                    "X11::${_component}")
	endif()
ENDFOREACH ()

FIND_PACKAGE_HANDLE_STANDARD_ARGS(X11
    REQUIRED_VARS
        X11_LIBRARIES
        X11_INCLUDE_DIR
    HANDLE_COMPONENTS
    VERSION_VAR
        X11_VERSION)


if(X11_LIBRARIES)
    list(REMOVE_DUPLICATES X11_LIBRARIES)
endif()
if(X11_INCLUDE_DIR)
    list(REMOVE_DUPLICATES X11_INCLUDE_DIR)
endif()
if(X11_TARGETS)
    list(REMOVE_DUPLICATES X11_TARGETS)
endif()
  set(CMAKE_FIND_FRAMEWORK ${CMAKE_FIND_FRAMEWORK_SAVE})
  set(CMAKE_REQUIRED_QUIET ${CMAKE_REQUIRED_QUIET_SAVE})
endif ()

# X11_FIND_REQUIRED_<component> could be checked too
