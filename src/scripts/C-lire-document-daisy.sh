#!/bin/bash
#
# Version : 1.0
# Licence : GPL v3
# Maintenance : Christophe L. et association ACIAH
# Nom : Lire-document-daisy
# DESCRIPTION : Script permettant de lire des documents daisy avec daisy-player
# DEPENDANCES : le script nécessite les paquets pdftotext, espeak, mbrola
# RACCOURCIS : ce script est placé dans le dossier $HOME/.config/caja/scripts
# et est appelé par le raccourci : F11
# 
#   
aplay /usr/local/share/advl/beep.wav
espeak -a 200 -v mb-fr1 -s 130 "désactivez le lecteur d'écran en faisant : insert + s"          
# Variables :

ICONS="/usr/share/icons/hicolor/48x48/apps/daisy-player.png"
TITLE="Daisy Player - Lecture de : "

# Fonctions :

notify(){
  echo "$1"
  [ "$scr1" = "1" ]  && espeak -v $TYPE -s $SPEED -p $PITCH "$TITLE/. /$1/.  /$Texte/." | mbrola $VOIX - -.au | aplay &
  notify-send -i "$ICONS" "$TITLE" "$1"
  sleep 5
}

##### capture filepath #####
dir=$(pwd)

if pgrep "orca" > /dev/null; then
    scr=1
else
    scr=0
fi

cd $dir
Document=$@


file=$(basename "$Document")
notify "$file"
x-terminal-emulator -e daisy-player $Document

exit 0
