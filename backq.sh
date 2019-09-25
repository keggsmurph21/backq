#!/bin/bash
#
# Kevin Murphy
# 9/25/19

# only use for interactive shells
[[ $- == *i* ]] || return

__back_init() {
    local back_dir=~/.cache/back/$$
    mkdir -p $back_dir
    export BACKQ=$back_dir/backq
    export FWQ=$back_dir/fwq
    touch $BACKQ $FWQ
    alias __cd="$(builtin cd)"
}

__back_exit() {
    rm -rf $(dirname $BACKQ)
}

__back_debug() {
    echo $BACKQ contents:
    cat $BACKQ
    echo $FWQ contents:
    cat $FWQ
}

__cd() {
    builtin cd $1
}

cd() {
    [ ! -d "$1" ] && return
    pwd >> $BACKQ
    echo > $FWQ
    __cd $1
}

back() {
    if [ -s $BACKQ ]; then
        target="$(tail -n1 $BACKQ)"
        pwd >> $FWQ
        sed -i '$ d' $BACKQ
        __cd "$target"
    else
        echo "cannot go back any farther" >&2
    fi
}

fw() {
    if [ -s $FWQ ]; then
        target="$(tail -n1 $FWQ)"
        pwd >> $BACKQ
        sed -i '$ d' $FWQ
        __cd "$target"
    else
        echo "cannot go fw any farther" >&2
    fi
}

__back_init             # initialize
trap __back_exit EXIT   # clean up
