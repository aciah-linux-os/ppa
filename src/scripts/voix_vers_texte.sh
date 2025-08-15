#!/bin/bash
# VERSION 1.0
# Auteur : association ACIAH, juin 2025
# Licence : GPL - v3
# Modifications :
# Nom : voi_vers_texte
# DESCRIPTION : je parle et l'ordinateur écrit
# DEPENDANCES : le script nécessite le paquet xdotool 
# COMPLEMENTS : 
# RACCOURCIS : ce script est placé dans le dossier /usr/local/bin

# Ouvre Google Chrome avec l'URL
google-chrome-stable "https://www.textfromtospeech.com/fr/voice-to-text/" &

# Attend quelques secondes pour laisser le temps à Chrome de s'ouvrir
sleep 5

# Simule le raccourci Alt+d pour sélectionner la barre d'adresse
#xdotool search --onlyvisible --class "google-chrome" windowactivate --sync key Alt+d
xdotool key "Alt+x"
sleep 0.5
xdotool key "Alt+d"

espeak -a 300 -v mb-fr1 -s 130 "parlez maintenant"

