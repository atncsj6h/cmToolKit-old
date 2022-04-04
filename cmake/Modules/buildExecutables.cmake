#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Copyright (c) 2020-2021 Enrico Sorichetti
#   Distributed under the Boost Software License, Version 1.0.
#   (See accompanying file BOOST_LICENSE_1_0.txt or copy at
#   http://www.boost.org/LICENSE_1_0.txt)
#
include_guard( GLOBAL )

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
function( build_executable )
  set( args "${ARGV}" )
  list( SORT args )
  list( REMOVE_DUPLICATES args )
  foreach( argv ${args} )

    add_executable( ${argv}
      ${${argv}_SRCS}
    )

    set_target_properties( ${argv}
      PROPERTIES
      OUTPUT_NAME ${argv}
    )
    if( HAVE_IPO_SUPPORT )
      set_property( TARGET ${argv}
        PROPERTY
        INTERPROCEDURAL_OPTIMIZATION TRUE
      )
    endif()
    target_link_libraries( ${argv}
      ${${argv}_LIBS}
    )
    install( TARGETS ${argv}
      LIBRARY
      DESTINATION ${INST_LIB_DIR}
    )
  endforeach()

endfunction()

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
function( create_symlink target alias)
  add_custom_command(
    TARGET ${target}
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E chdir ${CMAKE_RUNTIME_OUTPUT_DIRECTORY} ln -sf ${target} ${alias}
    DEPENDS ${target}
  )

  install( FILES ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${alias}
    DESTINATION ${INST_BIN_DIR}
  )
endfunction( create_symlink )



