#!/bin/bash

WT_TITLE="Partitionner"
WT_MSG="Cette manipulation est dangeureuse !"

_warningbox

# Recuperation des disques disponibles grace a la commande lsblk
DRIVES=$(lsblk -do name,size | tail -n +2 | awk '{if (NR == 1){ \
    print "/dev/null 0G ON \n/dev/"$0, "OFF"} else \
    {print "/dev/"$0, "OFF"}}')

WT_RADIO=($DRIVES)
WT_MSG="Quelle disque choisir ?"

_radiobox

if [ $WT_EXIT_STATUS = 0 ]; then

    WT_MSG="Etes vous sur de vouloir lancer la commande suivante ?\n \
    fdisk '$WT_RADIO_CHOICE'"

    _questionbox

    if [ $WT_EXIT_STATUS = 0 ]; then
        # Lancement de la commande
        fdisk "$WT_RADIO_CHOICE"
        FDISK_STATUS=$?

        if [ $FDISK_STATUS != 0 ]; then
            WT_MSG="Erreur lors de l'execution!"
            _errbox
        else
            WT_MSG="Commande termine"
            _msgbox
        fi
    fi

fi
