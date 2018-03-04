#!/bin/bash

WT_TITLE="Systeme de fichiers"
WT_MSG="Cette manipulation est dangeureuse !"

_warningbox

# Recuperation des partitions disponibles grace a la commande lsblk
DRIVES=$(lsblk -lo name,size,type | grep 'part' | rev | \
    cut -c 5- | rev | awk '{if (NR == 1){ \
    print "/dev/null 0G ON \n/dev/"$0, "OFF"} else \
    {print "/dev/"$0, "OFF"}}')

WT_RADIO=($DRIVES)
WT_MSG="Quelle partition choisir ?"

_radiobox

if [ $WT_EXIT_STATUS = 0 ]; then

    WT_MSG="Etes vous sur de vouloir lancer la commande suivante ?\n \
    mke2fs -j '$WT_RADIO_CHOICE'"

    _questionbox

    if [ $WT_EXIT_STATUS = 0 ]; then
        # Lancement de la commande
        mke2fs -j "$WT_RADIO_CHOICE"
        MKE2FS_STATUS=$?

        if [ $MKE2FS_STATUS != 0 ]; then
            WT_MSG="Erreur lors de l'execution!"
            _errbox
        else
            WT_MSG="Commande termine"
            _msgbox
        fi
    fi

fi
