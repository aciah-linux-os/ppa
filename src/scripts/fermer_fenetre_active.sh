# !/bin/bash

# C’est habituellement avec le raccourci : Alt + F4 que l’on ferme une fenêtre.
# Mais on peut avoir envie d’affecter ce raccourci à une seule touche du clavier, par exemple F4

# ferme la fenêtre active
# nécessite d’avoir installé les outils : xdotool et espeak
xdotool getwindowfocus
sleep 0.5
xdotool key alt+F4
espeak -a 200 -v mb-fr1 -s 130 "fenêtre fermée"
exit 0

