#!/bin/bash

WT_TITLE="Sauvegarde"
WT_MSG="Quelle est la partition a sauvegarder"
WT_INPUT_DEFAULT=""

_inputbox

LPE_DEV_P=$WT_INPUT_CHOICE

if [ $WT_EXIT_STATUS = 0 ]; then
    dump -0 -f "saves/$(date '+%F-%T')" "$LPE_DEV_P"
    DUMP_STATUS=$?

    if [ $DUMP_STATUS != 0 ]; then
        WT_MSG="Erreur lors de l'execution!"
        _errbox
    else
        WT_MSG="Sauvgarde"
        _msgbox
    fi
fi
