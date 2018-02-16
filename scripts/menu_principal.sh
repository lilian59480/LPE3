#!/bin/bash

WT_TITLE="Menu principal"
WT_MSG="Choissisez une action a effectuer"
WT_MENU=("<-- Back" "Return to the main menu." \
    "Add User" "Add a user to the system." \
    "Modify User" "Modify an existing user." \
    "List Users" "List all users on the system." \
    "Add Group" "Add a user group to the system." \
    "Modify Group" "Modify a group and its list of members." \
    "List Groups" "List all groups on the system.")

_menubox

if [ $WT_EXIT_STATUS = 0 ]; then
    echo "Choix: " $WT_MENU_CHOICE
else
    echo "Annule"
fi


