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
set( _ATTRS "__attribute__((always_inline))" "inline" "__inline" "__inline__"  )

cmake_push_check_state( RESET )
set( CMAKE_REQUIRED_FLAGS "-Wall -Werror" )

foreach( _attr ${_ATTRS} )
  unset( attr_flag  )
  unset( attr_flag CACHE )
  check_c_source_compiles("
    ${_attr} int foo()
    {
      return 0;
    }
    static
    ${_attr} int foo_s()
    {
      return 0;
    }
    int main()
    {
      int f, f_s;
      f=foo();
      f_s=foo_s();
      return 0;
    } "
    attr_flag
  )
  if( attr_flag )
    cmake_pop_check_state()
    set( INLINE "${_attr}" )
    return()
  endif()
endforeach()

cmake_pop_check_state()
unset( INLINE )
unset( INLINE CACHE )

