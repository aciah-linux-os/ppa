#!/bin/bash
# VERSION 1.0
# Auteur : association ACIAH
# Licence : GPL - v3
# Modifications :
# Nom : aller-ala-racine
# DESCRIPTION : une seule touche pour aller à la racine de l'arborescence, script destiné aux personnes qui n'ont qu'une main.
# DEPENDANCES : le script nécessite le paquet  xdotool
# COMPLEMENTS : 
# RACCOURCIS : ce script est placé dans le dossier /usr/local/bin
#
sleep 0.5 && xdotool key Alt+Home
exit 0
