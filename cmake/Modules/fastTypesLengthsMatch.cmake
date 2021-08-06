#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Copyright (c) 2020-2021 Enrico Sorichetti
#   Distributed under the Boost Software License, Version 1.0.
#   (See accompanying file BOOST_LICENSE_1_0.txt or copy at
#   http://www.boost.org/LICENSE_1_0.txt)

include_guard( GLOBAL )

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
include( CMakePushCheckState )
include( CheckCSourceRuns )

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
cmake_push_check_state( RESET )
set( CMAKE_REQUIRED_FLAGS "-Wall -Werror" )

unset( FAST_TYPES_LENGTHS_MATCH )
unset( FAST_TYPES_LENGTHS_MATCH CACHE )

check_c_source_runs( "
  #include <stdint.h>
  int main(){
    if ( sizeof(  int8_t) != sizeof(  int_fast8_t) ) return (1) ;
    if ( sizeof( int16_t) != sizeof( int_fast16_t) ) return (1) ;
    if ( sizeof( int32_t) != sizeof( int_fast32_t) ) return (1) ;
    if ( sizeof( int64_t) != sizeof( int_fast64_t) ) return (1) ;
    if ( sizeof( uint8_t) != sizeof( uint_fast8_t) ) return (1) ;
    if ( sizeof(uint16_t) != sizeof(uint_fast16_t) ) return (1) ;
    if ( sizeof(uint32_t) != sizeof(uint_fast32_t) ) return (1) ;
    if ( sizeof(uint64_t) != sizeof(uint_fast64_t) ) return (1) ;
    return (0);
  }"
  FAST_TYPES_LENGTHS_MATCH
)

cmake_pop_check_state()
