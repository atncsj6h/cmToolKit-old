#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Copyright (c) 2020-2021 Enrico Sorichetti
# Distributed under the Boost Software License, Version 1.0.
# (See accompanying file BOOST_LICENSE_1_0.txt or copy at
# http://www.boost.org/LICENSE_1_0.txt)

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
include_guard( GLOBAL )
include( CMakePushCheckState )

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
function( sysctl ctlvar )
  set( _s "
    #include <stdint.h>
    #include <inttypes.h>
    #include <stdio.h>
    #include <stdlib.h>
    #include <sys/sysctl.h>
    int main()  {
    int64_t retval;
    size_t  size;
    sysctlbyname( \"${ctlvar}\", NULL, &size, NULL, 0);
    if ( size != sizeof( retval) )
      return (0);
    sysctlbyname( \"${ctlvar}\", &retval, &size, NULL, 0);
    printf( \"%lli\", retval ) ;
    return (1);
    } "
  )
  file( WRITE "${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeTmp/src.c"
    "${_s}\n" )

  cmake_push_check_state( RESET )
  set( CMAKE_REQUIRED_FLAGS "-Wall -Werror" )

  try_run( run_rc compile_rc
    ${CMAKE_BINARY_DIR}
    ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeTmp/src.c
    RUN_OUTPUT_VARIABLE run_out
    COMPILE_OUTPUT_VARIABLE compile_out
  )
  cmake_pop_check_state()

  # vsnap( _s compile_rc run_rc compile_out run_out )
  if( compile_rc AND  run_rc )
    string( MAKE_C_IDENTIFIER "${ctlvar}" cmakevar )
    string( TOUPPER "${cmakevar}" cmakevar )
    string( REPLACE "_" " " cmakevar "${cmakevar}" )
    string( STRIP "${cmakevar}" cmakevar )
    string( REPLACE " " "_" cmakevar "${cmakevar}" )
    set( "${cmakevar}" "${run_out}"  PARENT_SCOPE )
  else()
    message( FATAL_ERROR "
 unable to process sysctl request for '${ctlvar}' " )
  endif()

endfunction()
