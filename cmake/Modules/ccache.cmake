#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Copyright Enrico Sorichetti 2020 - 2021
#   Distributed under the Boost Software License, Version 1.0.
#   (See accompanying file BOOST_LICENSE_1_0.txt or copy at
#   http://www.boost.org/LICENSE_1_0.txt)

include_guard( GLOBAL )

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
set( _generators "Unix Makefiles" "Ninja" )

if( "${CMAKE_GENERATOR}" IN_LIST _generators  )
  find_program(CCACHE ccache)
  if( CCACHE )
    set_property(GLOBAL PROPERTY RULE_LAUNCH_COMPILE "${CCACHE}")
  else()
    message( WARNING "
 CCACHE requested, but 'ccache' program not found " )
  endif()

else()
  message( WARNING "
 CCACHE requested, but not supported for '${CMAKE_GENERATOR}' " )

endif()

