# This script should be sourced inside your .bashrc

ON_LEAVE=".on_leave"
ON_ENTER=".on_enter"

function process_cd() {
    src=$1
    dst=$2
    while [[ $dst != $src* ]]; do
        [ -f "$src/$ON_LEAVE" ] && source "$src/$ON_LEAVE" "$src" "$dst"
        src=`dirname "$src"`
    done
    next=${dst#$src}
    OLD=$IFS
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
            [ -f "$src/$ON_ENTER" ] && source "$src/$ON_ENTER" "$src" "$dst"
        fi
    done
    IFS=$OLD
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

process_cd "$HOME" "$PWD" 