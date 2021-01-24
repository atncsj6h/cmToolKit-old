#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Copyright Enrico Sorichetti 2020 - 2021
#   Distributed under the Boost Software License, Version 1.0.
#   (See accompanying file BOOST_LICENSE_1_0.txt or copy at
#   http://www.boost.org/LICENSE_1_0.txt)

include_guard( GLOBAL )

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
include( CheckIncludeFile )

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
function( check_header )
  set( args "${ARGV}" )
  list( SORT args )
  list( REMOVE_DUPLICATES args )
  list( FILTER args EXCLUDE REGEX "^(HAVE_)" )

  foreach( argv ${args} )
    string( MAKE_C_IDENTIFIER "have_${argv}" flag )
    string( TOUPPER "${flag}" flag)
    check_include_file( ${argv} ${flag} )
  endforeach()

endfunction()
