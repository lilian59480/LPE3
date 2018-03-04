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

function _warningbox {
    NEWT_COLORS='
        window=,brightred
        border=white,brightred
        textbox=white,brightred
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
    WT_EXIT_STATUS=$?
}

function _questionbox {
    "$WHIPTAIL" --backtitle "$WT_BACKTITLE" \
        --title "$WT_TITLE" \
        --yesno "$WT_MSG" 0 0
    WT_EXIT_STATUS=$?
}

function _radiobox {
    WT_RADIO_CHOICE=$("$WHIPTAIL" --backtitle "$WT_BACKTITLE" \
        --title "$WT_TITLE" \
        --radiolist "$WT_MSG" 0 0 0 "${WT_RADIO[@]}" 3>&1 1>&2 2>&3)
    WT_EXIT_STATUS=$?
}

function _inputbox {
    WT_INPUT_CHOICE=$("$WHIPTAIL" --backtitle "$WT_BACKTITLE" \
        --title "$WT_TITLE" \
        --inputbox "$WT_MSG" 0 0 "$WT_INPUT_DEFAULT" 3>&1 1>&2 2>&3)
    WT_EXIT_STATUS=$?
}

# Merci à https://stackoverflow.com/a/10792311
# Afin de fournir qqchose de pratique
function _downloadbox { 
    wget "$WT_URL" --show-progress -O "$WT_PATH" 2>&1 | stdbuf -o0 awk '/[.] +[0-9][0-9]?[0-9]?%/ { print substr($0,63,3) }' | \
        "$WHIPTAIL" --backtitle "$WT_BACKTITLE" \
        --title "$WT_TITLE" \
        --gauge "$WT_MSG" 0 0 0
}

