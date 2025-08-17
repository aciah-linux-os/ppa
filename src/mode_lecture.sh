!/bin/sh
# VERSION 1.0
# Auteur : association ACIAH
# Licence : GPL - v3
# Modifications :
# Nom : Mode lecture
# DESCRIPTION : passer un article en mode lecture avec firefox - touche F9 
# DEPENDANCES : le script nécessite le paquet xdotool 
# COMPLEMENTS : 
# RACCOURCIS : ce script est placé dans le dossier /usr/local/bin

STATE_FILE="/tmp/mode_lecture_state"

 # Petite pause pour laisser Firefox réagir
    sleep 1

 # Simulation de Ctrl+Alt+R
    xdotool key "Ctrl+Alt+r"

    if [ ! -f "$STATE_FILE" ]; then
        # Pas encore en mode lecture → on active
        espeak -a 200 -v mb-fr1 -s 130 "passage en mode lecture"
        touch "$STATE_FILE"
    else
        # Déjà en mode lecture → on désactive
        espeak -a 200 -v mb-fr1 -s 130 "mode lecture terminé"
        rm -f "$STATE_FILE"
    fi
