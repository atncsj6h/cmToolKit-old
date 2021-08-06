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

#[[ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#]]
set( _s "
  #include <stdint.h>
  #include <stdio.h>
  int main()
  {
    return printf(\"%zu\", SIZE_MAX);
  }"
)

#[[ - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#]]
cmake_push_check_state( RESET )
set( CMAKE_REQUIRED_FLAGS "-Wall -Werror" )

unset( HAVE_BROKEN_SIZE_MAX )
unset( HAVE_BROKEN_SIZE_MAX CACHE )

check_c_source_runs( "${_s}"
  HAVE_BROKEN_SIZE_MAX
)

cmake_pop_check_state()
