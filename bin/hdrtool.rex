#! /usr/bin/env rexx

Trace "O"
signal on novalue name novalue

ignore_hdrs = .array~of( ,
  "config.h" ,
  "sdkddever.h" ,
  )

ISO_hdrs_sets = .array~of("c90", "c95", "c99", "c11")

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ISO/IEC 9899:1990 (C89, C90) headers
*/
c90 = "c90"
hdrs_class.c90 = "ISO/IEC 9899:1990 (C89, C90) headers"
hdrs.c90 = .array~of( ,
  "assert.h", "ctype.h",  "errno.h",  "float.h", ,
  "limits.h", "locale.h", "math.h",   "setjmp.h", ,
  "signal.h", "stdarg.h", "stddef.h", "stdio.h", ,
  "stdlib.h", "string.h", "time.h")

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ISO/IEC 9899:1990/Amd.1:1995 (c95) headers - shorthand
*/
c95 = "c95"
hdrs_class.c95 = "ISO/IEC 9899:1990/Amd.1:1995 headers"
hdrs.c95 = .array~of( ,
  "iso646.h", "wchar.h",  "wctype.h")

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ISO/IEC 9899:1999 (C99)
*/
c99 = "c99"
hdrs_class.c99 = "ISO/IEC 9899:1999 (C99) headers"
hdrs.c99 = .array~of( ,
  "complex.h",    "fenv.h",   "inttypes.h",   "stdbool.h", ,
  "stdint.h",     "tgmath.h")

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ISO/IEC 9899:2011 (C11)
*/
c11 = "c11"
hdrs_class.c11 = "ISO/IEC 9899:2011 (C11) headers"
hdrs.c11 = .array~of( ,
  "stdalign.h",   "stdatomic.h",  "stdnoreturn.h",    "threads.h", ,
  "uchar.h")

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  non ISO/IEC headers (used in the source tree)
*/
OTH_hdrs_sets  = .array~of("toplevl", "subdirs")

toplevl = "toplevl"
hdrs_class.toplevl = "non ISO/IEC headers - include top level"
hdrs.toplevl = .array~new

subdirs = "subdirs"
hdrs_class.subdirs = "non ISO/IEC headers - include subdirectories"
hdrs.subdirs = .array~new

hdrs = .array~new
command = "collect.sh c_headers ."
Address "" command  with output using (hdrs)
hdrs~append("sys/xattr.h")
hdrs~append("inttypes.h")

hdrs~sort

hdrs = hdrs~difference(ignore_hdrs)
do set over ISO_hdrs_sets
  hdrs.set = hdrs.set~intersection(hdrs)
  hdrs = hdrs~difference(hdrs.set)
end

do  hdr over hdrs
  dir = filespec("P", hdr)
  if  dir = "" then ,
    hdrs.toplevl~append(hdr)
  else ,
    hdrs.subdirs~append(hdr)
end


/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
*/
headers_cmake = .array~new
headers_h_in  = .array~new

headers_cmake~appendall(cm_box())
headers_cmake~append("include( CheckIncludeFile )")
headers_cmake~append("include( checkHeader )")
headers_cmake~append(" ")
headers_h_in~appendall(cc_box())
headers_h_in~append("#ifndef HEADERS_H_INCLUDED ")
headers_h_in~append("#define HEADERS_H_INCLUDED ")
headers_h_in~append(" ")

hdrs_sets = .array~new
hdrs_sets~appendall(ISO_hdrs_sets)
hdrs_sets~appendall(OTH_hdrs_sets)

do set over hdrs_sets
  if  hdrs.set~isempty then ,
    iterate

  headers_cmake~appendall(cm_box(hdrs_class.set))
  headers_cmake~append("check_header(")

  headers_h_in~appendall(cc_box(hdrs_class.set))

  do hdr over hdrs.set
    hdrs~removeItem(hdr)

    headers_cmake~append(copies(" ", 4)||hdr)

    headers_h_in~append("/* Define to 1 if you have the '<"hdr">' header file. */")
    headers_h_in~append("#cmakedefine "have_flag(hdr))
  end

  headers_cmake~append(copies(" ", 4)||")")
  headers_cmake~append(" ")

  headers_h_in~append(" ")
end

headers_h_in~append("#endif  /* HEADERS_H_INCLUDED */ ")

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
*/
if  hdrs~isempty then do
  if \fwrite( "headers.cmake", headers_cmake) then ,
    signal logic_error
  if \fwrite( "headers.h.in", headers_h_in) then ,
    signal logic_error
end
else do
  say headers_cmake
  say headers_h_in
  signal logic_error
end

exit

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
*/
fread:procedure
  use strict arg file
  hand = .stream~new(file)
  if  hand~open( "read" ) \= "READY:" then ,
    signal logic_error
  arr = hand~arrayin
  if  hand~close \= "READY:" then ,
    signal logic_error
  return arr

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
*/
fwrite:procedure
  use strict arg file, arr
  say "*****" file
  hand = .stream~new(file)
  if  hand~open( "write replace" ) \= "READY:" then ,
    signal logic_error
  if  hand~arrayout(arr) \= 0 then ,
    signal logic_error
  if  hand~close \= "READY:" then ,
    signal logic_error
  return .true

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
*/
cc_box: procedure
  parse arg txt
  box = .array~new
  box~append("/*  "copies("- ", 38))
  if  txt \= "" then ,
    box~append(copies(" ", 4)||txt)
  box~append("*/")
  return box

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
*/
cm_box: procedure
  parse arg txt
  box = .array~new
  box~append("#[[ "copies("- ", 38))
  if  txt \= "" then ,
    box~append(copies(" ", 4)||txt)
  box~append("#]]")
  return box

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
*/
have_flag: procedure
  use strict arg what
  flag = translate("have_"what)
  flag = translate(flag, "____", " /-.")
  return flag

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
*/
logic_error:
say  "**  " || copies("- ", 38)
say  "**  " || "Logic error at line '"sigl"' "
say  "**  "
exit

/*  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
*/
novalue:
say  "**  " || copies("- ", 38)
say  "**  " || "Novalue trapped, line '"sigl"' var '"condition("D")"' "
say  "**  "
exit
