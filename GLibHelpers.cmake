find_package(GLibTools REQUIRED)

macro(add_glib_marshal outsources outincludes name prefix)
  add_custom_command(
    OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/${name}.h"
    COMMAND ${GLIB-GENMARSHAL_EXECUTABLE} --header "--prefix=${prefix}"
            "${CMAKE_CURRENT_SOURCE_DIR}/${name}.list"
            > "${CMAKE_CURRENT_BINARY_DIR}/${name}.h"
    DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/${name}.list"
  )
  add_custom_command(
    OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/${name}.c"
    COMMAND ${GLIB-GENMARSHAL_EXECUTABLE} --body "--prefix=${prefix}"
            "${CMAKE_CURRENT_SOURCE_DIR}/${name}.list"
            > "${CMAKE_CURRENT_BINARY_DIR}/${name}.c"
    DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/${name}.list"
            "${CMAKE_CURRENT_BINARY_DIR}/${name}.h"
  )
  list(APPEND ${outsources} "${CMAKE_CURRENT_BINARY_DIR}/${name}.c")
  list(APPEND ${outincludes} "${CMAKE_CURRENT_BINARY_DIR}/${name}.h")
endmacro(add_glib_marshal)

macro(add_glib_enumtypes outsources outheaders name)
    set(files ${ARGN})
	add_custom_command(
	  OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/${name}.h"
	  COMMAND ${GLIB-MKENUMS_EXECUTABLE} ARGS --template ${name}".h.template"
          ${files}
		  > "${CMAKE_CURRENT_BINARY_DIR}/${name}.h"
	  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
	  DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/${name}.h.template"
		${files}
	)
	add_custom_command(
		OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/${name}.c"
		COMMAND ${GLIB-MKENUMS_EXECUTABLE} ARGS --template ${name}".c.template"
                ${files}
			> "${CMAKE_CURRENT_BINARY_DIR}/${name}.c"
		WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
		DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/${name}.c.template"
			${files}
	)
	list(APPEND ${outsources} "${CMAKE_CURRENT_BINARY_DIR}/${name}.c")
	list(APPEND ${outheaders} "${CMAKE_CURRENT_BINARY_DIR}/${name}.h")
endmacro(add_glib_enumtypes)
#.rst:
#.. command:: add_gdbus_codegen
#
#  Generates C code and header file from XML service description, and
#  appends the sources to the SOURCES list provided.
#
#    add_gdbus_codegen(<SOURCES> <NAME> <PREFIX> <SERVICE_XML> [NAMESPACE])
#
#  For example:
#
#  .. code-block:: cmake
#
#   set(MY_SOURCES foo.c)
#
#   add_gdbus_codegen(MY_SOURCES
#     dbus-proxy
#     org.freedesktop
#     org.freedesktop.DBus.xml
#     )
#
function(ADD_GDBUS_CODEGEN _SOURCES _NAME _PREFIX SERVICE_XML)
  set(_options ALL)
  set(_oneValueArgs NAMESPACE)

  cmake_parse_arguments(_ARG "${_options}" "${_oneValueArgs}" "" ${ARGN})

  get_filename_component(_ABS_SERVICE_XML ${SERVICE_XML} ABSOLUTE)

  set(_NAMESPACE "")
  if(_ARG_NAMESPACE)
    set(_NAMESPACE "--c-namespace=${_ARG_NAMESPACE}")
  endif()

  set(_OUTPUT_PREFIX "${CMAKE_CURRENT_BINARY_DIR}/${_NAME}")
  set(_OUTPUT_FILES "${_OUTPUT_PREFIX}.c" "${_OUTPUT_PREFIX}.h")

  # for backwards compatibility
  set("${_SOURCES}_SOURCES" "${_OUTPUT_FILES}" PARENT_SCOPE)


  list(APPEND ${_SOURCES} ${_OUTPUT_FILES})
  set(${_SOURCES} ${${_SOURCES}} PARENT_SCOPE)

  add_custom_command(
    OUTPUT ${_OUTPUT_FILES}
    COMMAND "${GDBUS-CODEGEN_EXECUTABLE}"
        --interface-prefix ${_PREFIX}
        --generate-c-code="${_NAME}"
        ${_NAMESPACE}
        ${_ABS_SERVICE_XML}
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    DEPENDS ${_ABS_SERVICE_XML}
    )
endfunction()
