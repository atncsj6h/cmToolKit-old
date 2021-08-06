#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Copyright (c) 2020-2021 Enrico Sorichetti
# Distributed under the Boost Software License, Version 1.0.
# (See accompanying file BOOST_LICENSE_1_0.txt or copy at
# http://www.boost.org/LICENSE_1_0.txt)
#
include_guard( GLOBAL )

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
function( build_config_pc )
  set( args "${ARGV}" )
  list( SORT args )
  list( REMOVE_DUPLICATES args )
  foreach( argv ${args} )
    if( EXISTS ${CMAKE_SOURCE_DIR}/${argv}.pc.in )
      configure_file( ${CMAKE_SOURCE_DIR}/${argv}.pc.in
        ${CMAKE_BINARY_DIR}/${argv}.pc @ONLY )
    else()
      configure_file( $ENV{CMTK}/cmake/Templates/config.pc.in
        ${CMAKE_BINARY_DIR}/${argv}.pc @ONLY )
    endif()

    install( FILES ${CMAKE_BINARY_DIR}/${argv}.pc
        DESTINATION ${INST_LIB_DIR}/pkgconfig )

    # extra location based on the environment variable PKG_CONFIG_PATH
    set( PKG_CONFIG_PATH "$ENV{PKG_CONFIG_PATH}" )
    if( PKG_CONFIG_PATH )
      string( REGEX REPLACE "[:]" ";" PKG_CONFIG_PATH "${PKG_CONFIG_PATH}")
      list( GET PKG_CONFIG_PATH 0 PKG_CONFIG_PATH )
      if( IS_DIRECTORY ${PKG_CONFIG_PATH} )
        install( FILES ${CMAKE_BINARY_DIR}/${argv}.pc
          DESTINATION ${PKG_CONFIG_PATH} )
      endif()
    endif()
  endforeach()
endfunction()

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
function( build_config_sh )
  set( args "${ARGV}" )
  list( SORT args )
  list( REMOVE_DUPLICATES args )
  foreach( argv ${args} )
    if( EXISTS ${CMAKE_SOURCE_DIR}/${argv}-config.in )
      configure_file( ${CMAKE_SOURCE_DIR}/${argv}-config.in
        ${CMAKE_BINARY_DIR}/${argv}-config @ONLY )
    else()
      configure_file( $ENV{CMTK}/cmake/Templates/config.sh.in
         ${CMAKE_BINARY_DIR}/${argv}-config @ONLY )
    endif()

    install( FILES ${CMAKE_BINARY_DIR}/${argv}-config
      PERMISSIONS OWNER_WRITE
        OWNER_READ  OWNER_EXECUTE
        GROUP_READ  GROUP_EXECUTE
        WORLD_READ  WORLD_EXECUTE
      DESTINATION ${INST_BIN_DIR}
    )
  endforeach()
endfunction()
