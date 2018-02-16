#!/bin/bash

WT_TITLE="Menu principal"
WT_MSG="Choissisez une action a effectuer"
WT_MENU=("Compiler" "Compiler les elements de notre systeme" \
    "Creer le systeme" "Creer une partition et le necessaire pour le systeme" \
    "Sauvegarder" "Sauvegarder la partition" \
    "Restaurer" "Restaurer la partition")

_menubox

if ! [ $WT_EXIT_STATUS = 0 ]; then
    exit 0
fi


