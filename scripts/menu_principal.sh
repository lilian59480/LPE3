#!/bin/bash

WT_TITLE="Menu principal"
WT_MSG="Choissisez une action a effectuer"
WT_MENU=("Compiler" "Compiler les elements de notre systeme" \
    "Creer le systeme" "Creer une partition et le necessaire pour le systeme" \
    "Sauvegarder" "Sauvegarder la partition" \
    "Restaurer" "Restaurer la partition")
QUIT_MENU=0
_menubox

if ! [ $WT_EXIT_STATUS = 0 ]; then
    exit 0
fi

case "$WT_MENU_CHOICE" in
    "Compiler")
        while [ $QUIT_MENU = 0 ]; do
            . scripts/menu_compilation.sh
        done 
    ;;
    "Creer le systeme")
        while [ $QUIT_MENU = 0 ]; do
            . scripts/menu_creation.sh
        done 
    ;;
    "Sauvegarder")
        . scripts/menu_sauvegarder.sh
    ;;
    "Restaurer")
        . scripts/menu_restaurer.sh
    ;;
    *)
    ;;
esac

