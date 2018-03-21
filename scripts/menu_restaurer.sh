#!/bin/bash

WT_TITLE="Restaurer"
WT_MSG="Quelle est le point de montage?"
WT_INPUT_DEFAULT=""

_inputbox

LPE_MOUNT=$WT_INPUT_CHOICE
SAVE_DIR="$(pwd)/saves/"

WT_MSG="Quelle est la sauvegarde que vous voulez charger?"

# Listage des fichiers dans le dossier saves
LPE_TEMP="ON"
FICHIERS=""
for file in "saves/*"; do
    FICHIERS="$FICHIERS $file $LPE_TEMP"
    LPE_TEMP="OFF"
done

WT_RADIO=($FICHIERS)

_radiobox

if [ $WT_EXIT_STATUS = 0 ]; then
    $(cd "$LPE_MOUNT" && no | restore -x -f "$SAVE_DIR/$WT_RADIO_CHOICE")
    RESTORE_STATUS=$?

    if [ $RESTORE_STATUS != 0 ]; then
        WT_MSG="Erreur lors de l'execution!"
        _errbox
    else
        WT_MSG="Restauration terminee"
        _msgbox
    fi
fi
