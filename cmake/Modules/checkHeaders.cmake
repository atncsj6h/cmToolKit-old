#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Copyright (c) 2020-2021 Enrico Sorichetti
#   Distributed under the Boost Software License, Version 1.0.
#   (See accompanying file BOOST_LICENSE_1_0.txt or copy at
#   http://www.boost.org/LICENSE_1_0.txt)

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
include_guard( GLOBAL )

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
include( CMakePushCheckState )
include( CheckIncludeFiles)

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
function( check_headers )
  set( args "${ARGV}" )
  list( SORT args )
  list( REMOVE_DUPLICATES args )

  unset( required )
  unset( required CACHE )
  string( TOLOWER "${args}" args_lc )
  list( FIND args_lc "required" _X )
  if( _X GREATER_EQUAL 0 )
    list( REMOVE_AT args_lc "${_X}" )
    list( REMOVE_AT args "${_X}" )
    set( required ON )
  endif()

  cmake_push_check_state( RESET )
  foreach( argv ${args} )
    string( REGEX REPLACE "[ ]+" ";" argv "${argv}" )
    list( LENGTH argv _X )
    math( EXPR _X "${_X} - 1" OUTPUT_FORMAT DECIMAL)
    list(GET argv  ${_X} flag )
    string( MAKE_C_IDENTIFIER "have_${flag}" flag )
    string( TOUPPER "${flag}" flag)
    check_include_files( "${argv}" ${flag} )
    if( required AND NOT ${flag} )
      message( SEND_ERROR "header '${argv}' not available" )
    endif()
  endforeach()
  cmake_pop_check_state()

endfunction()
