#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Copyright (c) 2020-2021 Enrico Sorichetti
# Distributed under the Boost Software License, Version 1.0.
# (See accompanying file BOOST_LICENSE_1_0.txt or copy at
# http://www.boost.org/LICENSE_1_0.txt)

include_guard( GLOBAL )

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#

set( PKG_CONFIG_EXECUTABLE "$ENV{PKG_CONFIG_EXECUTABLE}" )
if( NOT PKG_CONFIG_EXECUTABLE )
  set( PKG_CONFIG_EXECUTABLE "pkgconf" )
endif()

unset( PKG_CONFIG_FOUND )
unset( PKG_CONFIG_FOUND CACHE )
include( FindPkgConfig )
if( NOT PKG_CONFIG_FOUND )
  message( SEND_ERROR "
 'pkgconf/pkg-config' not available/installed " )
endif()

#[[ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#]]
macro( pkg_config )
  string( TOLOWER "${ARGV}" args )
  list( SORT args )
  list( REMOVE_DUPLICATES args )

  unset( required )
  unset( required CACHE )

  list( FIND args "required" _X )
  if( _X GREATER_EQUAL 0 )
    list( REMOVE_AT args "${_X}" )
    set( required ON )
  endif()

  foreach( argv ${args} )
    pkg_check_modules( "${argv}" "${argv}" )
    if( required AND NOT ${argv}_FOUND )
      message( SEND_ERROR "
 unable to locate a required '${argv}' component "
      )
    endif()
    if( ${argv}_FOUND )
      # hack to fill the STATIC_LINK_LIBRARIES FULL PATH
      get_filename_component( _dir "${${argv}_LINK_LIBRARIES}" DIRECTORY )
      get_filename_component( _wle "${${argv}_LINK_LIBRARIES}" NAME_WLE )
      get_filename_component( _lxt "${${argv}_LINK_LIBRARIES}" LAST_EXT )
      if( EXISTS "${_dir}/${_wle}.a" )
        set( ${argv}_STATIC_LINK_LIBRARIES "${_dir}/${_wle}.a" )
      endif()
    endif()
  endforeach()
endmacro()
