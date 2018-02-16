#!/bin/bash

WHIPTAIL="whiptail"

if ! [ -x "$(command -v $WHIPTAIL)" ]; then
    echo "Erreur: $WHIPTAIL n'est pas installe" >&2
    exit 1
fi

WT_BACKTITLE="LPE Script"

function _errbox {
    NEWT_COLORS='
        window=,red
        border=white,red
        textbox=white,red
        button=black,white'\
            "$WHIPTAIL" --backtitle "$WT_BACKTITLE" \
            --title "$WT_TITLE" \
            --msgbox "$WT_MSG" 0 0
}

function _msgbox {
    "$WHIPTAIL" --backtitle "$WT_BACKTITLE" \
        --title "$WT_TITLE" \
        --msgbox "$WT_MSG" 0 0
}

function _menubox {
    WT_MENU_CHOICE=$("$WHIPTAIL" --backtitle "$WT_BACKTITLE" \
        --title "$WT_TITLE" \
        --menu "$WT_MSG" 0 0 0 "${WT_MENU[@]}" 3>&1 1>&2 2>&3)
}




