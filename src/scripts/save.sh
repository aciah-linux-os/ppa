#!/bin/bash

# Version 1.3 - décembre 2025
# Auteur : Aciah-octobre 2023
# Licence : GPL v3
# Modifications : Association ACIAH et Gérard Ruau (membre association ACIAH) 02/06/2024
# NAME : save.sh
# DESCRIPTION : Ce script essaie de simplifier l'enregistrement de documents LibreOffice.
# RACCOURCI : Ce script est placé dans le dossier /usr/local/bin

# Il y a des réglages préalables à faire : 
# - dans libre-office, faire : outils -> options -> général et décocher la ligne "utiliser les boites de dialogue libre-office" - cliquer ensuite sur Appliquer puis sur valider.
# - dans /usr/local/bin/myGtk*/TestMenu.txt  il faut préparer le raccourci 'A'

# On lance le script save.sh en faisant le menu : Alt + AltGr et la touche A, à condition d'avoir réglé cela dans le menu (voir ci-dessus).
# L'enregistrement du fichier se fait automatiquement dans le dossier '$HOME/A-attente'.
# On a tout le temps pour taper un nom de fichier et valider.
# Après validation, le gestionnaire de fichiers s'ouvre dans le dossier '$HOME/A-attente'.
# 
#### Début du script
	aplay /usr/local/share/advl/beep.wav
	sleep 5

#### Les indications sont données au début du script car elles se superposent à Orca si elles sont placées à la fin
	espeak -a 200 -v mb-fr1 -s 130 "le fichier sera enregistré dans le dossier A-attente"
	sleep 1
#	espeak -a 200 -v mb-fr1 -s 130 "le dossier A-attente sera ouvert"	
	sleep 1
	espeak -a 200 -v mb-fr1 -s 130 "patientez"

#### Arrêt de la synthèse vocale Orca et le script se poursuit
if [ -n "$(ps -A | grep mbrola)" ] ; then
	killall -KILL mbrola && sleep 2
fi

#killall orca &
#sleep 3
#killall -9 speech-dispatcher &

amixer -q  -D pulse sset Master toggle

#### Si le dossier $HOME/A-attente n'existe pas, on le crée
    if [ ! -d $HOME/A-attente ]
        then
            mkdir $HOME/A-attente
    fi

#### Ouverture de la fenêtre 'Enregistrer sous'
	xdotool key ctrl+shift+s
	sleep 1



#### Récupération du nom de la fenêtre (Enregistrer)
	nameloe=$(xdotool getactivewindow getwindowname)

#### Commandes pour aller dans le dossier 'A-attente'
	xdotool key Alt+n
	sleep 1
	xdotool key Delete
	sleep 1
	xdotool type $HOME/A-attente
	sleep 1
	xdotool key Return
	sleep 1

#### Commandes pour se situer au bon endroit afin de taper le nom du fichier
	xdotool key Shift+Tab
	sleep 1
	xdotool key Alt+n
	sleep 1
	xdotool key Delete # => pour compatibilité LibreOffice 24.x
	sleep 1


amixer -q  -D pulse sset Master toggle

espeak -a 200 -v mb-fr1 -s 130 "maintenant écrivez le nom du fichier puis validez"
sleep 2

#### Commandes pour attendre la validation du nom du fichier et ouverture du gestionnaire de fichiers à la fermeture de la fenêtre 'Enregistrer sous'
#### La commande 'break' est là pour sortir d'une boucle infinie si non présente
	while :
		do
			if [ "$(xdotool getactivewindow getwindowname)" != "$nameloe" ]
				then
espeak -a 200 -v mb-fr1 -s 130 "fin de l'enregistrement du fichier."
				sleep 1
espeak -a 200 -v mb-fr1 -s 130 "Le fichier est enregistré dans le dossier A-Attente. Poursuivez l'écriture de votre texte"

# caja $HOME/A-attente
				break
			fi
		done

#### Ré-active la synthèse vocale Orca
#speech-dispatcher
#orca --replace &

	exit 0

