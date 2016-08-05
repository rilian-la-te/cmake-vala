macro(add_glib_marshal outsources outincludes name prefix)
  find_package(GLibTools REQUIRED)
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

macro(add_glib_enumtypes outsources outheaders name includeguard)
  find_package(GLibTools REQUIRED)
  set (HEADERS "")
  foreach(header ${ARGN})
    set (HEADERS ${HEADERS}\#include \\\"${header}\\\"\\n)
  endforeach(header)
  string(TOUPPER ${name} name_upper)
  string(REPLACE "-" "_" name_upper ${name_upper})

  add_custom_command(
    OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/${name}.h"
    COMMAND ${GLIB-MKENUMS_EXECUTABLE}
        --fhead \"\#ifndef __${includeguard}_${name_upper}_ENUM_TYPES_H__\\n\#define __${includeguard}_${name_upper}_ENUM_TYPES_H__\\n\\n\#include <glib-object.h>\\n\\nG_BEGIN_DECLS\\n\"
        --fprod \"\\n/* enumerations from \\\"@filename@\\\" */\\n\"
        --vhead \"GType @enum_name@_get_type \(void\)\;\\n\#define ${includeguard}_TYPE_@ENUMSHORT@ \(@enum_name@_get_type\(\)\)\\n\"
        --ftail \"\\nG_END_DECLS\\n\\n\#endif /* __${includeguard}_${name_upper}_ENUM_TYPES_H__ */\"
        ${ARGN} > "${CMAKE_CURRENT_BINARY_DIR}/${name}.h"
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    DEPENDS ${ARGN}
  )
  add_custom_command(
    OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/${name}.c"
    COMMAND ${GLIB-MKENUMS_EXECUTABLE}
        --fhead \"\#include \\"${name}.h\\"\\n${HEADERS}\"
        --fprod \"\\n/* enumerations from \\"@filename@\\" */\"
        --vhead \"GType\\n@enum_name@_get_type \(void\)\\n{\\n"  "static volatile gsize g_define_type_id__volatile = 0\;\\n"  "if \(g_once_init_enter \(&g_define_type_id__volatile\)\) {\\n"    "static const G@Type@Value values[] = {\"
        --vprod \""      "{ @VALUENAME@, \\"@VALUENAME@\\", \\"@valuenick@\\" },\"
        --vtail \""      "{ 0, NULL, NULL }\\n"    "}\;\\n"    "GType g_define_type_id = g_\@type\@_register_static \(\\"@EnumName@\\", values\)\;\\n"    "g_once_init_leave \(&g_define_type_id__volatile, g_define_type_id\)\;\\n"  "}\\n"  "return g_define_type_id__volatile\;\\n}\\n\"
            ${ARGN} > "${CMAKE_CURRENT_BINARY_DIR}/${name}.c"
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    DEPENDS ${ARGN}
            "${CMAKE_CURRENT_BINARY_DIR}/${name}.h"
  )
  list(APPEND ${outsources} "${CMAKE_CURRENT_BINARY_DIR}/${name}.c")
  list(APPEND ${outheaders} "${CMAKE_CURRENT_BINARY_DIR}/${name}.h")
endmacro(add_glib_enumtypes)