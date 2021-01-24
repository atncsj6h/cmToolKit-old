#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Copyright Enrico Sorichetti 2020 - 2021
# Distributed under the Boost Software License, Version 1.0.
# (See accompanying file BOOST_LICENSE_1_0.txt or copy at
# http://www.boost.org/LICENSE_1_0.txt)

include_guard( GLOBAL )

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
include( CMakePushCheckState )

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
function( sysconf sysvar )
  set( SOURCE "
    #include <unistd.h>
    #include <stdio.h>
    int main()  {
    int rc = sysconf( ${sysvar} );
    printf( \"%d\", rc );
    return (0) ;
    } "
  )
  file( WRITE "${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeTmp/src.c"
    "${SOURCE}\n" )

  cmake_push_check_state( RESET )
  set( CMAKE_REQUIRED_FLAGS "-Wall -Werror" )
  try_run( run_rc compile_rc
    ${CMAKE_BINARY_DIR}
    ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeTmp/src.c
    COMPILE_DEFINITIONS ${CMAKE_REQUIRED_DEFINITIONS}
    RUN_OUTPUT_VARIABLE run_out
    COMPILE_OUTPUT_VARIABLE compile_out
  )

  #   vsnap( SOURCE compile_rc run_rc )
  if( compile_rc AND ( "${run_rc}" EQUAL 0 ) )
    string( TOUPPER "${sysvar}" cmakevar )
    string( REPLACE "_" " " cmakevar "${cmakevar}" )
    string( STRIP "${cmakevar}" cmakevar )
    string( REPLACE " " "_" cmakevar "${cmakevar}" )
    set( "${cmakevar}" "${run_out}"  PARENT_SCOPE )
  else()
    message( FATAL_ERROR "
 unable to process sysconf request for '${sysvar}' " )
  endif()
  cmake_pop_check_state()

endfunction()
