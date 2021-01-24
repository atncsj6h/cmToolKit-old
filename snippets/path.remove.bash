#   path.remove
#   remove the current path from the PATH

#   remove path
remove_path()
{
    #   front/middle
    if  eval test -z "\"\${$1##$2:*}\"" -o -z "\"\${$1##*:$2:*}\"" ; then
        eval "$1=${!1/$2:/}"
        return
    fi
    #   tail
    if  eval test -z "\"\${$1%%*:$2}\"" ; then
        eval "$1=${!1/:$2/}"
        return
    fi
    #   only
    if  eval test -z "\"\${$1##$2}\"" ; then
        eval "$1=${!1/$2/}"
        return
    fi
}

#   the works
here="$(pwd)"
if ! test -d "${here}" ; then
    echo    "strange ... path not found '${here}'"
else
    remove_path PATH "${here}"
    export PATH
fi

#   cleanup
unset remove_path
