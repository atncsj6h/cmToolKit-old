#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Copyright (c) 2020-2021 Enrico Sorichetti
#   Distributed under the Boost Software License, Version 1.0.
#   (See accompanying file BOOST_LICENSE_1_0.txt or copy at
#   http://www.boost.org/LICENSE_1_0.txt)

include_guard( GLOBAL )

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
if( 0 )
if( CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT )
  get_filename_component( _root ${CMAKE_BINARY_DIR} DIRECTORY )
  get_filename_component( _pref ${CMAKE_BINARY_DIR} NAME )
  #   backtrack once
  get_filename_component( _pref ${_pref} NAME_WLE)
  #   check if we need to backtrack again
  if( "${_root}/${_pref}" STREQUAL "${CMAKE_SOURCE_DIR}" )
    get_filename_component( _pref ${_pref} NAME_WLE)
  endif()
  set( CMAKE_INSTALL_PREFIX  "${_root}/${_pref}" )
endif()
endif( 0 )

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
set( WELL_KNOWN_PREFIX_LIST  /usr /usr/local /opt /opt/local )
include( GNUInstallDirs )

set( INST_PREFIX  "${CMAKE_INSTALL_PREFIX}" )

set( INST_BIN_DIR "${CMAKE_INSTALL_BINDIR}" )

set( INST_INC_DIR "${CMAKE_INSTALL_INCLUDEDIR}" )

set( INST_LIB_DIR "${CMAKE_INSTALL_LIBDIR}" )

set( INST_PKGCONF "${INST_LIB_DIR}/pkgconfig" )

set( INST_MOD_DIR "${INST_LIB_DIR}" )
set( INST_MOD_DIR_QUALIFIED "${INST_LIB_DIR}/${PROJECT_NAME}" )

set( INST_LIBEXEC_DIR "${CMAKE_INSTALL_LIBEXECDIR}" )

set( INST_SHR_DIR "${CMAKE_INSTALL_DATADIR}" )
set( INST_SHR_DIR_QUALIFIED "${INST_SHR_DIR}/${PROJECT_NAME}" )

set( INST_MAN_DIR "${CMAKE_INSTALL_MANDIR}" )

