#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Copyright Enrico Sorichetti 2020 - 2021
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
  message( WARNING "
 pkgconf/pkg-config not available/installed " )
endif()

#[[ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#]]
function( pkg_config)
  set( args "${ARGV}" )
  list( REMOVE_DUPLICATES args )
  foreach( argv ${args} )
    pkg_check_modules( "${argv}" "${argv}" )
  endforeach()
endfunction()
