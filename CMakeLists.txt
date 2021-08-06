#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Copyright (c) 2020-2021 Enrico Sorichetti
#   Distributed under the Boost Software License, Version 1.0.
#   (See accompanying file BOOST_LICENSE_1_0.txt or copy at
#   http://www.boost.org/LICENSE_1_0.txt)

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
message( STATUS "CMake version  '${CMAKE_VERSION}'" )
message( STATUS "Processing     '${CMAKE_CURRENT_LIST_FILE}'" )

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
if( CMAKE_VERSION VERSION_LESS  3.18 )
  message( FATAL_ERROR "
 CMake '3.18' or higher is required,
 You are running '${CMAKE_VERSION}'" )
endif()
cmake_minimum_required( VERSION ${CMAKE_VERSION} )

if( DEFINED ENV{CMTK} )
  set( CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR} )
  list( APPEND CMAKE_MODULE_PATH "$ENV{CMTK}/cmake/Modules" )
else()
  message( FATAL_ERROR "
 unable to locate the 'cmToolKit' cmake/Modules directory" )
endif()

include( vDump )
include( vDrop )
include( vSnap )

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   deprecate 'in-source' builds ( source directory/subdirectories )
#   if You accidentally try an 'in-source' build
#   You will have to manually clean up the leftovers :
#   file 'CMakeCache.txt' and directory 'CMakeFiles'

set( CMAKE_DISABLE_IN_SOURCE_BUILD ON )
set( CMAKE_DISABLE_SOURCE_CHANGES  ON )

get_filename_component( _s "${CMAKE_SOURCE_DIR}" REALPATH )
string( TOLOWER "${_s}" _s )

get_filename_component( _b "${CMAKE_BINARY_DIR}" REALPATH )
string( TOLOWER "${_b}" _b )

if( ( "${_b}" STREQUAL "${_s}" ) OR
    ( "${_b}" MATCHES  "${_s}/" ) )
  message( FATAL_ERROR "
 binary directory '${CMAKE_BINARY_DIR}'
 source directory '${CMAKE_SOURCE_DIR}'
 builds that modify the source directory/subdirectories are not allowed,
 remove file 'CMakeCache.txt' and directory 'CMakeFiles'" )
endif( )

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
project( sample
  VERSION 3.68.0
  LANGUAGES C CXX
)

set( PACKAGE sample )

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# we assume that the system has the ISO/IEC 9899:1999 (C99) headers
# and terminate if not
include( CheckIncludeFile )

check_include_file( stdbool.h  HAVE_STDBOOL_H )
check_include_file( stdint.h   HAVE_STDINT_H )
if( ( NOT HAVE_STDBOOL_H  ) OR
    ( NOT HAVE_STDINT_H ) )
  message( FATAL_ERROR "
 missing 'ISO/IEC 9899:1999 (C99)' headers" )
endif()
# just for consistency, the include(s) are not guarded
add_compile_definitions(
  HAVE_STDBOOL_H
  HAVE_STDINT_H
)

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
OPTION( WITH_IPO      ""  ON )
option( WITH_CCACHE   ""  ON )

OPTION( BUILD_SHARED  ""  ON )
OPTION( BUILD_STATIC  ""  ON )

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
set( CMAKE_POSITION_INDEPENDENT_CODE ON )
set( CMAKE_EXPORT_COMPILE_COMMANDS  ON )

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
if( WITH_IPO )
  include( CheckIPOSupported )
  check_ipo_supported( RESULT HAVE_IPO_SUPPORT )
  if ( HAVE_IPO_SUPPORT )
    message( STATUS "IPO is Supported and Enabled" )
  endif()
endif()

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
if( WITH_CCACHE )
  include( ccache )
endif()

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   FLAGS for NetBSD quirks
set( SYSTEM_NAME "${CMAKE_HOST_SYSTEM_NAME}" )
string( TOUPPER "${SYSTEM_NAME}" SYSTEM_NAME_UC  )
set( "${SYSTEM_NAME_UC}" 1 )
add_compile_definitions(
  SYSTEM_NAME="${SYSTEM_NAME}"
  ${SYSTEM_NAME_UC}
)

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   processor/architecture
set( TARG_PROCESSOR ${CMAKE_SYSTEM_PROCESSOR} )
if( CMAKE_SIZEOF_VOID_P MATCHES 8 )
  set( TARG_ARCHITECTURE "64" )
elseif( CMAKE_SIZEOF_VOID_P MATCHES 4 )
  set( TARG_ARCHITECTURE "32" )
else()
  message( FATAL_ERROR "
 unsupported Architecture " )
endif()
message( STATUS "Building for a ${TARG_ARCHITECTURE}-bit[s] architecture" )

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   endian-ness
include( TestBigEndian )
test_big_endian( HOST_BIGENDIAN )
if( HOST_BIGENDIAN )
  message( FATAL_ERROR "
 unsupported Endian-ness " )
endif()
vdrop( "HAVE_HOST_BIGENDIAN" quiet )
add_compile_definitions(
  TARG_LITENDIAN=1
)

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# compile_definitions
include( ${PACKAGE}_DEFS OPTIONAL )

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   setup the proper install paths according to the GNU standards,
include( installDirectories )

set( CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/${INST_BIN_DIR}" )
set( CMAKE_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/${INST_LIB_DIR}" )
set( CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/${INST_LIB_DIR}" )

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   the compiler flags
include( defaultCompilerFlags )

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
include( haveBrokenSizeMax )
include( fastTypesLengthsMatch )

include( __builtin_bswap )
include( __builtin_clz )

include( inlineAttr )
include( threadLocalAttr )

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
include( CheckTypeSize )
check_type_size( __int128 INT128_T )

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
include_directories(
  ${CMAKE_BINARY_DIR}
  ${CMAKE_SOURCE_DIR}
  ${CMAKE_SOURCE_DIR}/source/include
)

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   platform.h
if( EXISTS ${CMAKE_SOURCE_DIR}/platform.h.in )
  configure_file( ${CMAKE_SOURCE_DIR}/platform.h.in
    ${CMAKE_BINARY_DIR}/platform.h
  )
  add_compile_definitions(
    HAVE_PLATFORM_H
  )
endif()

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# sources
include( ${PACKAGE}_SRCS )

# headers
include( ${PACKAGE}_HDRS )

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   the libraries ( SHARED/STATIC )
include( buildLibraries )

build_object( ${PACKAGE} )

if( BUILD_SHARED )
  build_shared_library( ${PACKAGE} )
endif()

if( BUILD_STATIC )
  build_static_library( ${PACKAGE} )
endif()

add_library( ${PACKAGE}_IFACE INTERFACE
  ${${PACKAGE}_HDRS}
)
set_property( TARGET ${PACKAGE}_IFACE
  PROPERTY
  PUBLIC_HEADER ${${PACKAGE}_HDRS}
)
install( TARGETS ${PACKAGE}_IFACE
  PUBLIC_HEADER DESTINATION ${INST_INC_DIR}
)

if( TRUE )
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# ${PACKAGE}.pc ( extra locations )
macro( install_pc pkg )
  if( EXISTS ${CMAKE_BINARY_DIR}/${pkg}.pc )
    set( PKG_CONFIG_PATH "$ENV{PKG_CONFIG_PATH}" )
    if( PKG_CONFIG_PATH )
      string( REGEX REPLACE "[:]" ";" PKG_CONFIG_PATH "${PKG_CONFIG_PATH}")
      list( GET PKG_CONFIG_PATH 0 PKG_CONFIG_PATH )
      if( IS_DIRECTORY  ${PKG_CONFIG_PATH} )
        install( FILES ${CMAKE_BINARY_DIR}/${pkg}.pc
          DESTINATION ${PKG_CONFIG_PATH}
        )
      endif()
    endif()
    #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    #
    get_filename_component( _root ${CMAKE_SOURCE_DIR} DIRECTORY )
    install( FILES ${CMAKE_BINARY_DIR}/${pkg}.pc
      DESTINATION ${_root}/${INST_LIB_DIR}/pkgconfig
    )
  endif()
endmacro()

if( BUILD_SHARED )
  install_pc( ${PACKAGE} )
endif()
if( BUILD_STATIC )
  install_pc( ${PACKAGE}_STATIC )
endif()

endif( TRUE )

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   the uninstaller
configure_file( cmake_uninstall.cmake.in
  ${CMAKE_BINARY_DIR}/cmake_uninstall.cmake
  IMMEDIATE @ONLY )
add_custom_target( uninstall
  COMMAND ${CMAKE_COMMAND} -P ${CMAKE_BINARY_DIR}/cmake_uninstall.cmake )

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
include( configurationReport )

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
vdump( "main" "exit" )
