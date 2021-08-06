#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
# 
include( CheckIncludeFile )
include( checkHeader )
 
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
# ISO/IEC 9899:1990 (C89, C90) headers
check_header( required
  assert.h
  ctype.h
  errno.h
  float.h
  limits.h
  locale.h
  math.h
  setjmp.h
  signal.h
  stdarg.h
  stddef.h
  stdio.h
  stdlib.h
  string.h
  time.h
)
 
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
# ISO/IEC 9899:1990/Amd.1:1995 headers
check_header( required
  iso646.h
  wchar.h
  wctype.h
)
 
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
# ISO/IEC 9899:1999 (C99) headers
check_header( required
  complex.h
  fenv.h
  inttypes.h
  stdbool.h
  stdint.h
  tgmath.h
)
 
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
# ISO/IEC 9899:2011 (C11) headers
check_header( 
  stdalign.h
  stdatomic.h
  stdnoreturn.h
  threads.h
  uchar.h
)
 
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
# configure isohdrs.h
if( EXISTS ${TEMPL_SOURCE_DIR}/isohdrs.h.in )
  configure_file( ${TEMPL_SOURCE_DIR}/isohdrs.h.in
    ${CMAKE_BINARY_DIR}/isohdrs.h
  )
  add_compile_definitions(
    HAVE_ISOHDRS_H
  )
endif()
