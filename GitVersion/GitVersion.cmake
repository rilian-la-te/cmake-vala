macro(determine_fallback_version CMAKE_VERSION_MODULE_PATH)
    determine_fallback_version_for_subproject(${CMAKE_VERSION_MODULE_PATH} ${CMAKE_SOURCE_DIR})
endmacro()

macro(determine_fallback_version_for_subproject CMAKE_VERSION_MODULE_PATH CMAKE_VERSION_GIT_DIR)
    if(EXISTS ${CMAKE_VERSION_GIT_DIR}/.git)
        #
        # Make a version containing the current version from git.
        #

        include(GetGitRevisionDescription)
        git_describe(VERSION_LONG --tags)

        #parse the version information into pieces.
        string(REGEX REPLACE "^v*([0-9]+)\\..*" "\\1" GIT_VERSION_MAJOR "${VERSION_LONG}")
        string(REGEX REPLACE "^v*[0-9]+\\.([0-9]+).*" "\\1" GIT_VERSION_MINOR "${VERSION_LONG}")
        string(REGEX REPLACE "^v*[0-9]+\\.[0-9]+\\.([0-9]+).*" "\\1" GIT_VERSION_PATCH "${VERSION_LONG}")
        string(REGEX REPLACE "^v*[0-9]+\\.[0-9]+\\.[0-9]+(.*)" "\\1" GIT_VERSION_SHA1 "${VERSION_LONG}")
        set(VERSION_GIT "${GIT_VERSION_MAJOR}.${GIT_VERSION_MINOR}.${GIT_VERSION_PATCH}")
        file(WRITE ${CMAKE_VERSION_MODULE_PATH}/FallbackVersion.cmake "set(VERSION ${VERSION_GIT})\nset(VERSION_MAJOR ${GIT_VERSION_MAJOR})\nset(VERSION_MINOR ${GIT_VERSION_MINOR})\nset(VERSION_PATCH ${GIT_VERSION_PATCH})")
    endif()
endmacro()
