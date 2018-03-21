#!/bin/bash

WT_TITLE="Creation du systeme"
WT_MSG="Choissisez une action a effectuer"

if [ -z "$LPE_EMB" ]; then
    WT_MENU=("Partitionner" "Partitionner le disque" \
        "Systeme de fichiers" "Ajouter un systeme de fichier"\
        "Chemins" "Definir les chemins pour la creation"\
        "Copie (V2)" "Cle USB Bootable")
else
    WT_MENU=("Partitionner" "Partitionner le disque" \
        "Systeme de fichiers" "Ajouter un systeme de fichier"\
        "Chemins" "Chemin : $LPE_EMB"\
        "Copie (V1)" "Copie des fichiers de base"\
        "Copie (V2)" "Cle USB Bootable")
fi

_menubox

if ! [ $WT_EXIT_STATUS = 0 ]; then
    QUIT_MENU=1
fi

case "$WT_MENU_CHOICE" in
    "Partitionner")
        . scripts/creation_partitions.sh
    ;;
    "Systeme de fichiers")
        . scripts/creation_fs.sh
    ;;
    "Chemins")
        WT_MSG="Saisissez le point de montage du systeme"
        WT_INPUT_DEFAULT="/mnt/emb"

        _inputbox

        if [ $WT_EXIT_STATUS = 0 ]; then

        LPE_EMB=$WT_INPUT_CHOICE

        WT_MSG="Saisissez la partition a monter"
        WT_INPUT_DEFAULT=""

        _inputbox

        LPE_DEV_P=$WT_INPUT_CHOICE

        if [ $WT_EXIT_STATUS = 0 ]; then
            mount "$LPE_DEV_P" "$LPE_EMB"
            MOUNT_STATUS=$?

            if [ $MOUNT_STATUS != 0 ]; then
                WT_MSG="Erreur lors de l'execution!"
                _errbox
            else
                WT_MSG="Commande termine"
                _msgbox
            fi
        fi

        fi
    ;;
    "Copie (V1)")
        . scripts/creation_copiev1.sh
    ;;
    "Copie (V2)")
        . scripts/creation_copiev2.sh
    ;;
    *)
    ;;
esac

