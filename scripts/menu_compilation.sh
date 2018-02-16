#!/bin/bash

WT_TITLE="Compilation"
WT_MSG="Choissisez une action a effectuer"
WT_MENU=("Busybox" "Compiler Busybox" \
    "Kernel (noyau)" "Compiler le noyau Linux")

_menubox

if ! [ $WT_EXIT_STATUS = 0 ]; then
    QUIT_MENU=1
fi

case "$WT_MENU_CHOICE" in
    "Busybox")
        WT_TITLE="Compiler"
        WT_MSG="Compiler"
        _msgbox
    ;;
    "Kernel (noyau)")
        WT_TITLE="Creer le systeme"
        WT_MSG="Creer le systeme"
        _msgbox
    ;;
    *)
    ;;
esac

