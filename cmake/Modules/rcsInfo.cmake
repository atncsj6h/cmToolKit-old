#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Copyright (c) 2020-2021 Enrico Sorichetti
# Distributed under the Boost Software License, Version 1.0.
# (See accompanying file BOOST_LICENSE_1_0.txt or copy at
# http://www.boost.org/LICENSE_1_0.txt)

include_guard( GLOBAL )

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
macro( check_RCS _rcs)
  vsnap( _rcsxxx  )
  string( TOUPPER "${_rcs}_REPOSITORY" _rcs_flag )
  set( "${_rcs_flag}" TRUE )
  set( _rcs_path "${CMAKE_SOURCE_DIR}" )
  vsnap( _rcs_path )
  vsnap( _rcsxxx  )
  while( NOT EXISTS ${_rcs_path}/.${_rcsxxx} )
    get_filename_component( _rcs_path "${_rcs_path}" DIRECTORY )
    # message( FATAL_ERROR "just to get out ")
    vsnap( _rcs_path )
    if( _rcs_path STREQUAL "/" )
      set( "${_rcs_flag}" FALSE )
      return()
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
# message( ">> checking for Subversion " )
if( EXISTS ${CMAKE_SOURCE_DIR}/.svn )
  set( SVN_REPOSITORY TRUE )

  find_program( SVN_EXECUTABLE svn )
  if( SVN_EXECUTABLE )

    #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # subversion version
    set( _lc_all "$ENV{LC_ALL}" )
    set( ENV{LC_ALL} "C" )
    execute_process( COMMAND ${SVN_EXECUTABLE} --version
      WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
      RESULT_VARIABLE _res
      ERROR_VARIABLE  _err
      OUTPUT_VARIABLE _out
      OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    set( ENV{LC_ALL} "${_lc_all}" )
    check_RC( "${SVN_EXECUTABLE}" )
    string( REGEX REPLACE "^(.*\n)?svn, version ([.0-9]+).*"
      "\\2" SVN_VERSION_STRING "${_out}"
    )

    set( RCS_NAME "Svn" )
    set( RCS_VERSION "${SVN_VERSION_STRING}" )

    #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # WC revision
    set( _lc_all "$ENV{LC_ALL}" )
    set( ENV{LC_ALL} "C" )
    execute_process( COMMAND ${SVN_EXECUTABLE}
      info --show-item last-changed-revision
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    RESULT_VARIABLE _res
    ERROR_VARIABLE  _err
      OUTPUT_VARIABLE _out
      OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    set( ENV{LC_ALL} "${_lc_all}" )
    check_RC( "${SVN_EXECUTABLE}" )
    set( RCS_WC_REVISION "${_out}" )

    #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # the dirty flag
    set( _lc_all "$ENV{LC_ALL}" )
    set( ENV{LC_ALL} "C" )
    execute_process( COMMAND ${SVN_EXECUTABLE} diff --summarize
      WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
      RESULT_VARIABLE _res
      ERROR_VARIABLE  _err
      OUTPUT_VARIABLE _out
      OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    set( ENV{LC_ALL} "${_lc_all}" )
    check_RC( "${SVN_EXECUTABLE}" )
    if( "${_out}" STREQUAL "" )
      set( RCS_WC_DIRTY FALSE)
    else()
      set( RCS_WC_DIRTY TRUE )
    endif()

    #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # the revision string, RCS name, hash, revision(commit count), timestamp
    set( RCS_WC_REVISION_STRING "Svn" )
    if( RCS_WC_DIRTY )
      set( RCS_WC_REVISION_STRING "${RCS_WC_REVISION_STRING} R${RCS_WC_REVISION}[+]" )
    else()
      set( RCS_WC_REVISION_STRING "${RCS_WC_REVISION_STRING} R${RCS_WC_REVISION}[]" )
    endif()

    # message( ">> endif SVN_EXECUTABLE " )
    return()
  endif()
  # message( ">> endif SVN_REPOSITORY " )
endif()

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
# message( ">> checking for Git " )
if( EXISTS ${CMAKE_SOURCE_DIR}/.git )
  set( GIT_REPOSITORY TRUE )

  find_program( GIT_EXECUTABLE git )
  if( GIT_EXECUTABLE )

    #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # git version
    set( _lc_all "$ENV{LC_ALL}" )
    set( ENV{LC_ALL} "C" )
    execute_process( COMMAND ${GIT_EXECUTABLE} --version
      WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
      RESULT_VARIABLE _res
      ERROR_VARIABLE  _err
      OUTPUT_VARIABLE _out
      OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    set( ENV{LC_ALL} "${_lc_all}" )
    check_RC( "${GIT_EXECUTABLE}" )
    string( REGEX REPLACE "^(.*\n)?git version ([.0-9]+).*"
      "\\2" GIT_VERSION_STRING "${_out}"
    )

    set( RCS_NAME "Git" )
    set( RCS_VERSION "${GIT_VERSION_STRING}" )

    #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # WC revision
    set( _lc_all "$ENV{LC_ALL}" )
    set( ENV{LC_ALL} "C" )
    execute_process( COMMAND ${GIT_EXECUTABLE}
      rev-list HEAD --count
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

    #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # the revision string, RCS name, hash, revision(commit count), timestamp
    set( RCS_WC_REVISION_STRING "Git" )
    if( RCS_WC_DIRTY )
      set( RCS_WC_REVISION_STRING "${RCS_WC_REVISION_STRING} ${RCS_WC_REVISION}[${RCS_WC_HASH}+]" )
    else()
      set( RCS_WC_REVISION_STRING "${RCS_WC_REVISION_STRING} ${RCS_WC_REVISION}[${RCS_WC_HASH}]" )
    endif()

    # message( ">> endif GIT_FOUND  " )
    return()
  endif( GIT_FOUND )

  # message( ">> endif GIT_REPOSITORY " )
  return()
endif( GIT_REPOSITORY )


