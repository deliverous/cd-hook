# This script should be sourced inside your .bashrc

ON_LEAVE=".on_leave"
ON_ENTER=".on_enter"

function process_cd() {
    src=$1
    dst=$2
    while [[ $dst != $src* ]]; do
        [ -x "$src/$ON_LEAVE" ] && source "$src/$ON_LEAVE" "$src" "$dst"
        src=`dirname "$src"`
    done
    next=${dst#$src}
    IFS=/
    for i in $next; do
        if [[ $i != "" ]] 
        then 
            if [[ $src == "/" ]]
            then
                src="/$i"
            else
                src="$src/$i"
            fi
            [ -x "$src/$ON_ENTER" ] && source "$src/$ON_ENTER" "$src" "$dst"
        fi
    done
}


cd() {
    builtin cd "$@" && eval "process_cd \"$OLDPWD\" \"$PWD\""
}

pushd() {
    builtin pushd "$@" && eval "process_cd \"$OLDPWD\" \"$PWD\""
}

popd() {
    builtin popd "$@" && eval "process_cd \"$OLDPWD\" \"$PWD\""
}              
