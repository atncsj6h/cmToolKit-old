#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
message( STATUS "CMake version  '${CMAKE_VERSION}'" )
message( STATUS "Processing     '${CMAKE_CURRENT_LIST_FILE}'" )

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
if( CMAKE_VERSION VERSION_LESS  3.20 )
  message( FATAL_ERROR "
 CMake '3.20' or higher is required,
 You are running '${CMAKE_VERSION}'" )
endif()
cmake_minimum_required( VERSION ${CMAKE_VERSION} )

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
set( CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR} )
list( APPEND CMAKE_MODULE_PATH "$ENV{CMTK}/cmake/Modules" )

include( vDump )
include( vDrop )
include( vSnap )

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
project( tests
  VERSION 3.68.0
  LANGUAGES C CXX
)

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
include( checkfunctionexists )
include( checklibraryexists )


vdrop( CMAKE_REQUIRED_LIBRARIES quiet )
check_function_exists( sqrt HAVE_SQRT )
check_function_exists( crypt HAVE_CRYPT )

set( CMAKE_REQUIRED_LIBRARIES crypt )
check_library_exists( crypt crypt "" HAVE_LIBCRYPT )
set( CMAKE_REQUIRED_LIBRARIES "" )

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
vdump( "main" "exit" )
