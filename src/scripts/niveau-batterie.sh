#!/bin/bash

# Version 1.0 - février 2026
# Auteur : association ACIAH
# Licence : GPL v3
# Modifications : Association ACIAH et Gérard Ruau (membre association ACIAH) 22/02/2026
# NAME : niveau-batterie.sh
# DESCRIPTION : Ce script est destiné à déterminer le niveau de la  batterie d'un ordinateur portablme.'
# RACCOURCI : Ce script est placé dans le dossier /usr/local/bin
# nécessite le paquet acpi - qu'on peut installer avec : sudo apt install acpi
# pour l'utilisation, voir : https://aciah-linux.org/?article349

# Affiche le résultat de acpi
acpi

# Reste dans le terminal sans redonner la main
# (Ctrl+C pour sortir)
while true; do
    sleep 1
done
