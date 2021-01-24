#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Copyright Enrico Sorichetti 2020 - 2021
#   Distributed under the Boost Software License, Version 1.0.
#   (See accompanying file BOOST_LICENSE_1_0.txt or copy at
#   http://www.boost.org/LICENSE_1_0.txt)

include_guard( GLOBAL )

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
include( CMakePushCheckState )
include( CheckFunctionExists )

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
function( check_function )
  set( args "${ARGV}" )
  list( SORT args )
  list( REMOVE_DUPLICATES args )
  list(FILTER args EXCLUDE REGEX "^(HAVE_)" )

  cmake_push_check_state( RESET )
  foreach( argv ${args} )
    string( MAKE_C_IDENTIFIER "have_${argv}" flag )
    string( TOUPPER "${flag}" flag)
    check_function_exists( ${argv} ${flag} )
  endforeach()
  cmake_pop_check_state()

endfunction()

