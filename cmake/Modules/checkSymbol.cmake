#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Copyright (c) 2020-2021 Enrico Sorichetti
#   Distributed under the Boost Software License, Version 1.0.
#   (See accompanying file BOOST_LICENSE_1_0.txt or copy at
#   http://www.boost.org/LICENSE_1_0.txt)

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
include_guard( GLOBAL )

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
include( CMakePushCheckState )
include( CheckSymbolExists )

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
function( check_symbol )
  # sym, hdrlist, req
  set( decl "${ARGV0}" )
  set( hdrs "${ARGV1}" )

  set( flag "${decl}" )
  string( REPLACE "_" " "   flag "${flag}" )
  string( STRIP   "${flag}" flag )
  string( REPLACE " " "_"   flag "${flag}" )
  string( MAKE_C_IDENTIFIER "have_${flag}" flag )
  string( TOUPPER "${flag}" flag )

  cmake_push_check_state( RESET )
  check_symbol_exists( ${decl} ${hdrs} ${flag} )
  if( 0 AND ( ARGC GREATER 2 ) AND NOT ${flag} )
    message( SEND_ERROR "
 symbol '${sym}' not available in '${hdr}'" )
  endif()
  cmake_pop_check_state()

endfunction()
