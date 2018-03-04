#!/bin/bash

WT_TITLE="Creation du systeme"
WT_MSG="Choissisez une action a effectuer"
WT_MENU=("Partitionner" "Partitionner le disque" \
    "Systeme de fichiers" "Ajouter un systeme de fichier")

_menubox

if ! [ $WT_EXIT_STATUS = 0 ]; then
    QUIT_MENU=1
fi

case "$WT_MENU_CHOICE" in
    "Partitionner")
        . scripts/creation_partitions.sh
    ;;
    "Systeme de fichiers")
        WT_TITLE="FS"
        WT_MSG="Creer le systeme"
        _msgbox
    ;;
    *)
    ;;
esac

