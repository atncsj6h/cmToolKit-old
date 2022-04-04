#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Copyright (c) 2020-2021 Enrico Sorichetti
#   Distributed under the Boost Software License, Version 1.0.
#   (See accompanying file BOOST_LICENSE_1_0.txt or copy at
#   http://www.boost.org/LICENSE_1_0.txt)
#
include_guard( GLOBAL )

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
function( build_headers )
  set( args "${ARGV}" )
  list( SORT args )
  list( REMOVE_DUPLICATES args )
  foreach( argv ${args} )
    add_library( ${argv}_IFACE INTERFACE )
    set_property( TARGET ${argv}_IFACE
      PROPERTY
      PUBLIC_HEADER ${${argv}_HDRS}
    )
    install( TARGETS ${argv}_IFACE
      PUBLIC_HEADER DESTINATION ${INST_INC_DIR}
    )
  endforeach()
endfunction()

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
function( build_objects )
  set( args "${ARGV}" )
  list( SORT args )
  list( REMOVE_DUPLICATES args )
  foreach( argv ${args} )
    add_library( ${argv}_OBJECTS  OBJECT
      ${${argv}_SRCS}
    )
    set_target_properties( ${argv}_OBJECTS
      PROPERTIES
      POSITION_INDEPENDENT_CODE TRUE
      OUTPUT_NAME ${argv}
    )
    if( HAVE_IPO_SUPPORT )
      set_property( TARGET ${argv}_OBJECTS
        PROPERTY
        INTERPROCEDURAL_OPTIMIZATION TRUE
      )
    endif()
  endforeach()
endfunction()

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
function( build_shared_library )
  set( args "${ARGV}" )
  list( SORT args )
  list( REMOVE_DUPLICATES args )
  foreach( argv ${args} )
    add_library( ${argv} SHARED
      $<TARGET_OBJECTS:${argv}_OBJECTS>
    )
    set_target_properties( ${argv}
      PROPERTIES
      POSITION_INDEPENDENT_CODE TRUE
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
function( build_static_library)
  set( args "${ARGV}" )
  list( SORT args )
  list( REMOVE_DUPLICATES args )
  foreach( argv ${args} )
    add_library( ${argv}_STATIC STATIC
      $<TARGET_OBJECTS:${argv}_OBJECTS>
    )
    set_target_properties( ${argv}_STATIC
      PROPERTIES
      POSITION_INDEPENDENT_CODE TRUE
      OUTPUT_NAME ${argv}
    )
    if( HAVE_IPO_SUPPORT )
      set_property( TARGET ${argv}_STATIC
        PROPERTY
        INTERPROCEDURAL_OPTIMIZATION TRUE
      )
    endif()
    install( TARGETS ${argv}_STATIC
      ARCHIVE
      DESTINATION ${INST_LIB_DIR}
    )
  endforeach()
endfunction()

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
function( build_module)
  set( args "${ARGV}" )
  list( SORT args )
  list( REMOVE_DUPLICATES args )
  foreach( argv ${args} )
    add_library( ${argv} MODULE
      $<TARGET_OBJECTS:${argv}_OBJECTS>
    )
    set_target_properties( ${argv}
      PROPERTIES
      PREFIX ""
    )
    set_target_properties( ${argv}
      PROPERTIES
      POSITION_INDEPENDENT_CODE TRUE
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


