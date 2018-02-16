#!/bin/bash

set -x

# Recupére les options de base pour whiptail
. scripts/init_whiptail.sh 


WT_TITLE="Bienvenue"
WT_MSG="Bienvenue dans le script LPE3\nCreer par Lilian & Timothee"

_msgbox
