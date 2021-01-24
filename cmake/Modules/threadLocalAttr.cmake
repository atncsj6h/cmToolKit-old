#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Copyright Enrico Sorichetti 2020 - 2021
#   Distributed under the Boost Software License, Version 1.0.
#   (See accompanying file BOOST_LICENSE_1_0.txt or copy at
#   http://www.boost.org/LICENSE_1_0.txt)

include_guard( GLOBAL )

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
include( CMakePushCheckState )
include( CheckCSourceCompiles )

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
set( _ATTRS "__thread" "_Thread_local" )

cmake_push_check_state( RESET )
set( CMAKE_REQUIRED_FLAGS "-Wall -Werror" )

foreach( _attr ${_ATTRS} )
  unset( attr_flag  )
  unset( attr_flag CACHE )
  check_c_source_compiles("
    ${_attr} int i;
    int main()
    {
    return 0;
    }"
    attr_flag
  )
  if( attr_flag )
    cmake_pop_check_state()
    set( THREAD_LOCAL "${_attr}" )
    return()
  endif()
endforeach()

cmake_pop_check_state()
unset( THREAD_LOCAL )
unset( THREAD_LOCAL CACHE )

