#! /usr/bin/env bash

_me="`basename ${0}`"
_me="${_me%%.*}"

#   the name        "${<the var>%%.*}"
#   the extension   "${<the var>##*.}"

IFS=$'\n'
shopt -s extglob

if      [[ $#  > 1 ]] ; then
    echo "too many arguments"
    exit
elif    [[ $# == 1 ]] ; then
    TOP="$1"
else
    TOP="`pwd`"
fi

out="${_me}.$(basename ${TOP})"
out="${out//+([.\/\ ])/_}.txt"
rm -f ${out}

tmp="`mktemp -t ${_me}`"
src="`mktemp -t ${_me}`"
src="`basename ${src}`"
src="${src##*.}"

# ALL=$(find "${TOP}" -type f
#   -name "*.[ch]" -o -name "*.h.in" )

ALL=$(find ${TOP} -not -path '*/\.*' -type f \
     -name "*.c" -o -name "*.h" -o -name "*.h.in" \
  -o -name "*.cpp" -o -name "*.hpp" \
  -o -name "*.cxx" -o -name "*.hxx" )

cat ${ALL} \
  |sed -e 's+ ++g' \
  |grep "^#include" \
  |sed -e 's/#include<//' -e 's/#include"//'  \
  |sed -e 's/>.*$//' -e 's/".*$//'\
  |grep ".h$" \
  |sort |uniq \
    >"${tmp}"

while read hdr ; do

	dir="`dirname  ${hdr}`"
	if [ "$dir". == ".". ]; then
		dir=""
	else
	    dir="/$dir"
	fi

	nam="`basename ${hdr}`"
	#	special processing for config.h and platform.h
	if [ "${nam}". == "config.h". ]; then
		continue
	fi
	if [ "${nam}". == "platform.h". ]; then
		continue
	fi

  #   check if the header is in the hercules installed include
  fnd=$(find "${herc}/hyperion/include" -iname "${nam}")
  if [ "${fnd}". != . ] ;  then
    continue
  fi

    #   check if the header is somewhere in the sources path
    fnd=$(find "${TOP}" -iname "${nam}")
    if [ "${fnd}". != . ] ;  then
        continue
    fi

    #   try to compile a snippet using the header
    rm -f ${src}.c
    rm -f ${src}.o
    echo "#include <${hdr}>"     >  ${src}.c
    echo "int main(){}"         >>  ${src}.c
	  cc -c ${src}.c 1>/dev/null 2>/dev/null
    RC=$?
    echo "***** $RC $hdr"
    rm -f ${src}.o
    rm -f ${src}.c

    not=""
    sdkpath=$(xcrun --show-sdk-path)
    if test -d ${sdkpath}/usr/include${dir} ; then
        fnd=$(find ${sdkpath}/usr/include"${dir}" -maxdepth 1 -iname "${nam}" )
	    if [[ ${RC} == 0 ]] ; then
		    if [ "${fnd}". == . ] ;  then
			    not="HIDDEN"
            fi
	    else
		    if [ "${fnd}". == . ] ;  then
			    not="NOT_FOUND"
		    else
		        not="HAS_SPECIAL_NEEDS"
		    fi
        fi
    else
	    if [[ ${RC} == 0 ]] ; then
			  # not="LOGIC_ERROR"
	      not=""
	    else
			  not="NOT_FOUND"
      fi
    fi

    printf "%-20s %d %s\n" $hdr ${RC} $not>>${out}

done < ${tmp}

exit
