#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Copyright Enrico Sorichetti 2020 - 2021
# Distributed under the Boost Software License, Version 1.0.
# (See accompanying file BOOST_LICENSE_1_0.txt or copy at
# http://www.boost.org/LICENSE_1_0.txt)

include_guard( GLOBAL )

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
macro( check_RCS _rcs )
  string( TOUPPER "${_rcs}_REPOSITORY" _rcs_flag )
  set( "${_rcs_flag}" TRUE )
  set( _rcs_path "${CMAKE_SOURCE_DIR}" )
  while( NOT EXISTS ${_rcs_path}/.${_rcs})
    get_filename_component( _rcs_path "${_rcs_path}" DIRECTORY )
    if( _rcs_path STREQUAL "/" )
      set( "${_rcs_flag}" FALSE )
    endif()
  endwhile()
endmacro()

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
macro( check_RC _rcs )
  if( "${_res}" STREQUAL 0 )
  else()
    message( FATAL_ERROR "
 Command '${_rcs}' in '${CMAKE_SOURCE_DIR}' failed with error:
 ${_err} " )
  endif()
endmacro()

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# the commands should be executed with the C locale,
# otherwise the messages (which are parsed) might be translated
# set( _lc_all "$ENV{LC_ALL}" )
# set( ENV{LC_ALL} "C" )
# execute_process ... ...
# set( ENV{LC_ALL} "${_lc_all}" )

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
unset( RCS_NAME )
unset( RCS_VERSION )
unset( RCS_WC_REVISION )
unset( RCS_WC_HASH )
unset( RCS_WC_DIRTY )
unset( RCS_WC_TIMESTAMP)
unset( RCS_WC_REVISION_STRING )

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
check_RCS( "git" )
if( GIT_REPOSITORY )
  find_package( Git )
  if( GIT_FOUND )
    set( RCS_NAME "Git" )
    set( RCS_VERSION "${GIT_VERSION_STRING}" )

    #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # the revision ( AKA commit count )
    set( _lc_all "$ENV{LC_ALL}" )
    set( ENV{LC_ALL} "C" )
    execute_process( COMMAND ${GIT_EXECUTABLE} rev-list HEAD --count
      WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
      RESULT_VARIABLE _res
      ERROR_VARIABLE  _err
      OUTPUT_VARIABLE _out
      OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    set( ENV{LC_ALL} "${_lc_all}" )
    check_RC( "${GIT_EXECUTABLE}" )
    set( RCS_WC_REVISION "${_out}" )

    #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # the hash
    set( _lc_all "$ENV{LC_ALL}" )
    set( ENV{LC_ALL} "C" )
    execute_process( COMMAND ${GIT_EXECUTABLE} log -1 --pretty=format:%h
      WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
      RESULT_VARIABLE _res
      ERROR_VARIABLE  _err
      OUTPUT_VARIABLE _out
      OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    set( ENV{LC_ALL} "${_lc_all}" )
    check_RC( "${GIT_EXECUTABLE}" )
    set( RCS_WC_HASH "${_out}")

    #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # the dirty flag
    set( _lc_all "$ENV{LC_ALL}" )
    set( ENV{LC_ALL} "C" )
    execute_process( COMMAND ${GIT_EXECUTABLE} status --porcelain
      WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
      RESULT_VARIABLE _res
      ERROR_VARIABLE  _err
      OUTPUT_VARIABLE _out
      OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    set( ENV{LC_ALL} "${_lc_all}" )
    check_RC( "${GIT_EXECUTABLE}" )
    if( "${_out}" STREQUAL "" )
      set( RCS_WC_DIRTY FALSE)
    else()
      set( RCS_WC_DIRTY TRUE )
    endif()

    #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # the timestamp
    set( _lc_all "$ENV{LC_ALL}" )
    set( ENV{LC_ALL} "C" )
    execute_process( COMMAND ${GIT_EXECUTABLE} log -1 --pretty=format:%ci
      WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
      RESULT_VARIABLE _res
      ERROR_VARIABLE  _err
      OUTPUT_VARIABLE _out
      OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    set( ENV{LC_ALL} "${_lc_all}" )
    check_RC( "${GIT_EXECUTABLE}" )
    set( RCS_WC_TIMESTAMP "${_out}" )

    #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # the revision string, RCS name, hash, revision(commit count), timestamp
    set( RCS_WC_REVISION_STRING "${RCS_NAME}" )
    if( RCS_WC_DIRTY )
      set( RCS_WC_REVISION_STRING "${RCS_WC_REVISION_STRING}, hash[${RCS_WC_HASH}+]" )
    else()
      set( RCS_WC_REVISION_STRING "${RCS_WC_REVISION_STRING}, hash[${RCS_WC_HASH}]" )
    endif()
    set( RCS_WC_REVISION_STRING "${RCS_WC_REVISION_STRING}, commits(${RCS_WC_REVISION})" )
    set( RCS_WC_REVISION_STRING "${RCS_WC_REVISION_STRING}, date[${RCS_WC_TIMESTAMP}]" )

  endif( GIT_FOUND )

  return()

endif( GIT_REPOSITORY )



