#! /opt/homebrew/bin/bash

if  [ $#  -ne 2 ] ; then
    echo ""
    exit
fi

# asis          ${1}
# lower case    ${1,,}
# upper case    ${1^^}


if  [ "${1,,}".  == "all_files". ] ; then
  srcs=$(find ${2} -not -path '*/\.*' -type f)

  srcs=$(echo ${srcs} | tr -d "\n")

  for src in ${srcs} ; do
      echo ${src}
  done

  exit
fi

if  [ "${1,,}".  == "c_sources". ] ; then
  srcs=$(find ${2} -not -path '*/\.*' -type f \
       -name "*.c"   -o -name "*.h" \
    -o -name "*.cpp" -o -name "*.hpp" \
    -o -name "*.cxx" -o -name "*.hxx" \
    )

  srcs=$(echo ${srcs} | tr -d "\n")

  for src in ${srcs} ; do
    echo ${src}
  done

  exit
fi

if  [ "${1,,}".  == "c_headers". ] ; then
  if  test -f ${2} ; then
    srcs=${2}
  else
    srcs=$(find ${2} -not -path '*/\.*' -type f \
         -name "*.c"   -o -name "*.h" \
      -o -name "*.cpp" -o -name "*.hpp" \
      -o -name "*.cxx" -o -name "*.hxx" \
      )
    srcs=$(echo ${srcs} | tr -d "\n")
  fi

  hdrs=$(cat ${srcs} \
    |sed -e 's+ ++g' \
    |grep '#include<' \
    |sed -e 's/.*<//' -e 's/>.*$//' \
    |grep '\.h$' \
    |sort \
    |uniq \
    )

  hdrs=$(echo ${hdrs} | tr -d "\n")

  repo=$(realpath ${2})
  while [ "${repo}".  != "/". ] ; do
    if  [[ -d ${repo}/.git ]] || \
        [[ -d ${repo}/.svn ]] ; then
      break
    fi
    repo=$(dirname ${repo})
  done
  if  [ "${repo}".  == "/". ] ; then
    repo=$(realpath ${2})
  fi

  for hdr in ${hdrs} ; do
    fnd=$(find ${repo} -not -path '*/\.*' -type f \
      -name $(basename ${hdr}) \
    )
    if  [ "${fnd}".  == "". ] ; then
      echo ${hdr}
    fi
  done

  exit

fi

echo ""

exit
