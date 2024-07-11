# Script développé par Aciah et sous licence GPL3.
# Le script 'scanner.sh' a les fonctionnalités suivantes :

# - scanner un document et ouvrir le gestionnaire de fichier par le lancement d'un raccourci et lui donner un nom

# - les fichier obtenus seront OBLGATOIREMENT enregistrés dans le dossier '$HOME/Scan/nom_donné_par_l_utilisateur'
# - scanne un document à la résolution de 400dpi
  !!!! si le résultat du scan est en niveau de gris,
  !!!! veuillez indiquer le paramètre '--mode Color' juste avant '2>/dev/null' dans le script !!!! (voir les commentaires de la ligne 'scanimage')
# - conversion du document en trois fichiers : fichier.txt, fichier.png et fichier.pdf
# - à la suite des conversions, ouverture du gestionnaire de fichier Caja dans le dossier '$HOME//Scan/nom_donné_par_l_utilisateur'

# Pendant le déroulement du script, des indications sont données à l'écran et sont vocalisées par Orca si celui-ci est en service.
# Cela suit un timming calé pour un ordinateur de 2013 et peut être différent pour d'autres ordinateurs.
# Tous les chemins, paramètres et timming peuvent être modifiés dans le script, à vous de tester le bon fonctionnement ensuite.
# Pour le bon fonctionnement du script, l'ordre des commandes ne doit pas être modifié.

# Le script se trouve dans $HOME/.local/scripts/scanner.sh
# IL EST OBLIGATOIREMENT LANCÉ PAR LE RACCOURCI SUIVANT : xfce4-terminal -T scanner.sh --zoom=2 -e 'bash -c $HOME/.local/scripts//scanner.sh'

# Ce script a été testé sur Linux Mint 21.3 mais peut sûrement être adapté à d'autres distributions Linux.

# En cas de problème, contactez <aciah@free.fr>



#!/bin/bash

# VERSION 2
# LICENCE : GPL v3
# MODIFICATIONS : association ACIAH, Gérard Ruau (membre association ACIAH) 05/07/2024
# MAINTENANCE : <aciah@free.fr>
# NAME : scanner.sh
# DESCRIPTION : Script permettant de scanner un document, de le convertir en trois fichiers : fichier.png, fichier.txt et fichier.pdf.
#				L'utilisateur tapera un nom de fichier qui sera repris pour les trois fichiers.
#				Le même nom sera donné à un dossier qui se trouvera obligatoirement dans le dossier '$HOME/Scan/même_nom_de_fichier'
#				!!!! Il existe un autre script 'scanner.sh qui vocalise automatiquement le document obtenu !!!!
#
# DEPENDANCES : espeak, unoconv, pandoc, player.py, ghostscript, xdotool
#               !!!! unoconv génere une alerte car il est déprécié par Python et sera supprimé dans la version 3.12 => test remplacement en cours !!!!
# RACCOUCIS : Le script se trouve dans $HOME/.local/scripts/scanner.sh
#			  IL EST OBLIGATOIREMENT LANCÉ PAR LE RACCOURCI SUIVANT : xfce4-terminal -T scanner.sh --zoom=2 -e 'bash -c $HOME/.local/scripts/scanner.sh'
#
# Décommenter la ligne ci-dessous pour récupérer les log du script
#    exec 1>>/var/log/aciah/scanner.log 2>>/var/log/aciah/scanner.log


#### Si le dossier $HOME/Téléchargements/Scan n'existe pas, on le crée
    if [ ! -d $HOME/Scan ]
        then
            mkdir $HOME/Scan
    fi
  
aplay -q /usr/local/share/advl/beep.wav
sleep 1

#### Indications données à l'utilisateur pour la suite
echo "Assurez-vous que le scanner soit fonctionnel."
sleep 3
echo "Tapez un nom pour le document à scanner puis frappez la touche Entrée."
sleep 3

#### Lecture du nom tapé par l'utilisateur et déclaration de la variable "$Scan"
read Scan

#### Déclaration de la variable "$Repscan" pour la création du dossier '$HOME/Téléchargements/Scan/même_nom_de_fichier'
Repscan="$HOME"/Scan/"$Scan"

#### Si le dossier $HOME/Téléchargements/Scan/nom_donné_par_l'utilisateur n'existe pas, on le crée
    if [ ! -d "$Repscan" ]
        then
            mkdir "$Repscan"
    fi

#### Indications données à l'utilisateur pour la suite
echo "Trois fichiers seront créés : "$Scan.txt", "$Scan.png" et "$Scan.pdf"."
sleep 6
echo "Ils seront placés dans le dossier : "$Repscan", qui sera ouvert."
sleep 6

#### Indications données à l'utilisateur pour la suite
echo "Début du scan du document, patientez. Il y aura deux minutes de silence."
sleep 3

#### Scan du document et création du fichier temporaire image.tif avec une résolution de 400 dpi pour une meilleure définition des conversions à suivre
#### !!!! si le résultat du scan est en niveau de gris, veuillez indiquer le paramètre '--mode Color' juste avant '2>/dev/null' dans la ligne ci-dessous !!!! ####
scanimage -p -x 210 -y 297 --format=tiff --output-file "$Repscan"/"$Scan".tiff --resolution 400 2>/dev/null
sleep 2

#### Indications données à l'utilisateur pour la suite
echo "Conversion des fichiers en cours."
sleep 3

#### OCR du fichier image.tiff et conversion en un fichier.txt
echo "Création du fichier "$Scan".txt,"
tesseract "$Repscan"/"$Scan".tiff "$Repscan"/"$Scan" -l fra 2>/dev/null
sleep 2

#### Conversion du fichier image.tiff en un fichier.png et en un fichier.pdf
#### !!!! unoconv génere une alerte car il est déprécié par Python et sera supprimé dans la version 3.12 => test remplacement en cours !!!!
echo "Création du fichier "$Scan".png,"
unoconv --format png "$Repscan"/"$Scan".tiff --output "$Repscan" 2>/dev/null
sleep 2
echo "Création du fichier "$Scan".pdf, et encore une petite minute."
unoconv --format pdf "$Repscan"/"$Scan".tiff --output "$Repscan" 2>/dev/null
sleep 2

#### Réduction de la taille du fichier pdf (paramètre '-dPDFSETTINGS=/' :
#### 'printer' (300dpi) pour l'impression, 'ebook' (150dpi) pour une qualité intermédiaire, 'screen' (72dpi) pour l'affichage à l'écran)
gs -q -dSAFER -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -dPDFSETTINGS=/printer -sOUTPUTFILE="$Repscan"/"$Scan"_reduit.pdf -f "$Repscan"/"$Scan".pdf
sleep 1
mv "$Repscan"/"$Scan"_reduit.pdf "$Repscan"/"$Scan".pdf

rm "$Repscan"/"$Scan".tiff

echo "Le gestionnaire de fichiers ouvre le dossier : "$Repscan"."
sleep 6
nohup caja "$Repscan" 2>/dev/null &

aplay -q /usr/local/share/advl/beep.wav
aplay -q /usr/local/share/advl/beep.wav
exit 0
