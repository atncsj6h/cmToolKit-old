#! /usr/bin/env rexx
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    Copyright (c) 2020-2021 Enrico Sorichetti
    Distributed under the Boost Software License, Version 1.0.
    (See accompanying file BOOST_LICENSE_1_0.txt or copy at
    http://www.boost.org/LICENSE_1_0.txt)
*/
parse source . . path . .
this = filespec( "N", path )

svnu = value( "svnu", , "ENVIRONMENT" )
svnr = value( "svnr", , "ENVIRONMENT" )

count = 0

xlist ="CMakeLists.txt"

do  forever
  buffr = .input~linein
  if ( buffr = "" ) then do
    exit
  end
  if ( buffr[1] = " " | ,
    buffr[1] = "D" ) then ,
    iterate

  fpath = strip( substr( buffr, 3 ) )
  fname = filespec( "N", fpath)

  if wordpos( lower( fname ), xlist ) > 0 then ,
    iterate

  if _ISFILE( svnu"/"fpath ) then do
    "bbdiff --wait "  svnu"/"fpath  svnr"/"fpath ">/dev/null 2>&1 "
    if RC = 0 then ,
      say "'"this"'"  "   match" fpath "'"fname"'"
    else ,
      say "'"this"'"  "NO_match" fpath "'"fname"'"
  end
  else do
      say "'"this"'"  "NOTfound" fpath "'"fname"'"
  end

end

exit

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
*/

--
_EXISTS: procedure
    if  SysIsFile(arg(1)) then ,
        return .true
    if SysIsFileDirectory(arg(1)) then ,
         return .true
    return .false

--
_ISFILE: procedure
    if  SysIsFile(arg(1)) then ,
        return .true
    return .false

--
_ISDIR: procedure
    if  SysIsFileDirectory(arg(1)) then ,
        return .true
    return .false

