#!/bin/bash

WT_TITLE="Compilation de Busybox"
WT_MSG="Afin de compiler Busybox, nous allons \
telecharger l'archive sur le site."

_msgbox

# Creation du dossier
mkdir -p download/busybox/

WT_MSG="Voulez vous telecharger Busybox?"

_questionbox
WT_MSG="Chargement du menu de configuration"

if [ $WT_EXIT_STATUS = 0 ]; then
    # Sauvegarde
    rm -f download/busybox/busybox.tar.bz2~
    mv -f download/busybox/busybox.tar.bz2 download/busybox/busybox.tar.bz2~

    WT_MSG="Telechargement de Busybox"
    WT_URL="https://busybox.net/downloads/busybox-1.27.2.tar.bz2"
    WT_PATH="download/busybox/busybox.tar.bz2"

    _downloadbox
    WT_MSG="Telechargement termine. Chargement du menu de configuration"
fi

_msgbox

# Creation du dossier
mkdir -p compilation/busybox

tar -xjvf download/busybox/busybox.tar.bz2 -C compilation/busybox/ >> log.log

# Changement de dossier pour la compilation
cd compilation/busybox/busybox-1.27.2/

COMPILATION_STATUS=0

# Passage au menu de configuration
make menuconfig

# Puis compilation
(make && make install) >> ../../../log.log
COMPILATION_STATUS=$?

# On revient a notre dossier
cd ../../../

if [ $COMPILATION_STATUS != 0 ]; then
    WT_MSG="Erreur de compilation.\nVerifier les messages de log"
    _errbox
else
    WT_MSG="Compilation termine"
    _msgbox
fi

