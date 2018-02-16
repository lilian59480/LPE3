#!/bin/bash

set -x

# Prepare les fonctions pour whiptail
. scripts/init_whiptail.sh 


WT_TITLE="Bienvenue"
WT_MSG="Bienvenue dans le script LPE3\nCreer par Lilian & Timothee"

_msgbox

# On affiche le menu principal
while true; do
    . scripts/menu_principal.sh
done

