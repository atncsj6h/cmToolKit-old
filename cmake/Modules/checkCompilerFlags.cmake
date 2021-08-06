#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Copyright (c) 2020-2021 Enrico Sorichetti
# Distributed under the Boost Software License, Version 1.0.
# (See accompanying file BOOST_LICENSE_1_0.txt or copy at
# http://www.boost.org/LICENSE_1_0.txt)

include_guard( GLOBAL )

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
include( CMakePushCheckState )
include( CheckCCompilerFlag )

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
function( check_compiler_flags )
  set( args "${ARGV}")
  list( REMOVE_DUPLICATES args )

  list( FIND args "add_compile_options" _x )
  if( _x GREATER_EQUAL 0 )
    list( REMOVE_ITEM args "add_compile_options" )
    set( add_compile_options TRUE )
  endif()

  set( CMAKE_C_FLAGS_BAK "${CMAKE_C_FLAGS}" ) 
  set( CMAKE_C_FLAGS "" )
  cmake_push_check_state( RESET )
  set( CMAKE_REQUIRED_FLAGS "-Wall -Werror" )
  foreach( argv ${args} )
    string( REGEX REPLACE "[^a-zA-Z0-9_]" "_" flag "have_flag${argv}")
    string( TOUPPER "${flag}" flag )
    unset( "${flag}" )
    unset( "${flag}" CACHE )
    check_c_compiler_flag( ${argv} "${flag}" )
    if( ${flag} AND add_compile_options )
      add_compile_options( "${argv}" )
      unset( "${flag}" )
      unset( "${flag}" CACHE )
    endif()
  endforeach()
  cmake_pop_check_state()
  set( CMAKE_C_FLAGS "${CMAKE_C_FLAGS_BAK}" ) 
  set( CMAKE_C_FLAGS_BAK  "" )

endfunction()
