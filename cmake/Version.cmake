cmake_minimum_required (VERSION 3.4)

set (BARRIER_VERSION_MAJOR 2)
set (BARRIER_VERSION_MINOR 3)
set (BARRIER_VERSION_PATCH 1)

#
# Barrier Version
#
if (NOT DEFINED BARRIER_VERSION_MAJOR)
    if (DEFINED ENV{BARRIER_VERSION_MAJOR})
        set (BARRIER_VERSION_MAJOR $ENV{BARRIER_VERSION_MAJOR})
    else()
        set (BARRIER_VERSION_MAJOR 1)
    endif()
endif()

if (NOT DEFINED BARRIER_VERSION_MINOR)
    if (DEFINED ENV{BARRIER_VERSION_MINOR})
        set (BARRIER_VERSION_MINOR $ENV{BARRIER_VERSION_MINOR})
    else()
        set (BARRIER_VERSION_MINOR 9)
    endif()
endif()

if (NOT DEFINED BARRIER_VERSION_PATCH)
    if (DEFINED ENV{BARRIER_VERSION_PATCH})
        set (BARRIER_VERSION_PATCH $ENV{BARRIER_VERSION_PATCH})
    else()
        set (BARRIER_VERSION_PATCH 0)
        message (WARNING "Barrier version wasn't set. Set to ${BARRIER_VERSION_MAJOR}.${BARRIER_VERSION_MINOR}.${BARRIER_VERSION_PATCH}")
    endif()
endif()

if (NOT DEFINED BARRIER_VERSION_STAGE)
    if (DEFINED ENV{BARRIER_VERSION_STAGE})
        set (BARRIER_VERSION_STAGE $ENV{BARRIER_VERSION_STAGE})
    else()
        set (BARRIER_VERSION_STAGE "snapshot")
    endif()
endif()

if (NOT DEFINED BARRIER_REVISION)
    if (DEFINED ENV{GIT_COMMIT})
        string (SUBSTRING $ENV{GIT_COMMIT} 0 8 BARRIER_REVISION)
    else()
        find_program (GIT_BINARY git)
        if (NOT GIT_BINARY STREQUAL "GIT_BINARY-NOTFOUND")
            execute_process (
                COMMAND git rev-parse --short=8 HEAD
                WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
                OUTPUT_VARIABLE BARRIER_REVISION
                OUTPUT_STRIP_TRAILING_WHITESPACE
            )
        endif()
    endif()
endif()

string(LENGTH "${BARRIER_REVISION}" BARRIER_REVISION_LENGTH)
if (NOT BARRIER_REVISION_LENGTH EQUAL 8 OR NOT BARRIER_REVISION MATCHES "^[a-f0-9]+")
    set (BARRIER_REVISION "00000000")
    message (WARNING "revision not found. setting to ${BARRIER_REVISION}")
endif()
unset (BARRIER_REVISION_LENGTH)

if (DEFINED ENV{BUILD_NUMBER})
    set (BARRIER_BUILD_NUMBER $ENV{BUILD_NUMBER})
else()
    set (BARRIER_BUILD_NUMBER 1)
endif()

string (TIMESTAMP BARRIER_BUILD_DATE "%Y%m%d" UTC)
set (BARRIER_SNAPSHOT_INFO ".${BARRIER_VERSION_STAGE}.${BARRIER_REVISION}")

if (BARRIER_VERSION_STAGE STREQUAL "snapshot")
    set (BARRIER_VERSION_TAG "${BARRIER_VERSION_STAGE}.b${BARRIER_BUILD_NUMBER}-${BARRIER_REVISION}")
else()
    set (BARRIER_VERSION_TAG "${BARRIER_VERSION_STAGE}")
endif()

set (BARRIER_VERSION "${BARRIER_VERSION_MAJOR}.${BARRIER_VERSION_MINOR}.${BARRIER_VERSION_PATCH}-${BARRIER_VERSION_STAGE}")
set (BARRIER_VERSION_STRING "${BARRIER_VERSION}-${BARRIER_VERSION_TAG}")
message (STATUS "Full Barrier version string is '" ${BARRIER_VERSION_STRING} "'")

add_definitions (-DBARRIER_VERSION="${BARRIER_VERSION}")
add_definitions (-DBARRIER_VERSION_STRING="${BARRIER_VERSION_STRING}")
add_definitions (-DBARRIER_REVISION="${BARRIER_REVISION}")
add_definitions (-DBARRIER_BUILD_DATE="${BARRIER_BUILD_DATE}")
add_definitions (-DBARRIER_BUILD_NUMBER=${BARRIER_BUILD_NUMBER})

if (BARRIER_DEVELOPER_MODE)
    add_definitions (-DBARRIER_DEVELOPER_MODE=1)
endif()

