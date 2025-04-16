#!/bin/sh
echo "Paramétrage des raccourcis clavier."
xfconf-query --channel xfce4-keyboard-shortcuts --property "/commands/custom/F1" --create --type string --set aciah_ouvrir_menu_fichier
xfconf-query --channel xfce4-keyboard-shortcuts --property "/commands/custom/F4" --create --type string --set aciah_fermer_fenetre_active
echo "Fait."
exit 0
