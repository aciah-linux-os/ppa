#!/bin/bash
# VERSION 2.1
# LICENCE : GPL v3
# MODIFICATIONS : association ACIAH, Gérard Ruau (membre association ACIAH) 05/07/2024
# MAINTENANCE : <aciah@free.fr> 10/11/2025
# NAME : scanner.sh
# DESCRIPTION : Script permettant de scanner un document, de le convertir en trois fichiers : fichier.png, fichier.txt et fichier.pdf.
#				L'utilisateur tapera un nom de fichier qui sera repris pour les trois fichiers.
#				Le même nom sera donné à un dossier qui se trouvera obligatoirement dans le dossier '$HOME/Scan/même_nom_de_fichier'
#				!!!! Il existe un autre script 'scanner.sh qui vocalise automatiquement le document obtenu !!!!
#
# DEPENDANCES : espeak, pandoc, player.py, ghostscript, xdotool
#               unoconv, déprécié, a été remplacé.
# RACCOUCIS : Le script se trouve dans $HOME/.local/scripts/scanner.sh
#	      IL EST OBLIGATOIREMENT LANCÉ PAR LE RACCOURCI SUIVANT : xfce4-terminal -T scanner.sh --zoom=2 -e 'bash -c $HOME/.local/scripts/scanner.sh'

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

echo "Création du fichier $Scan.png, et encore une petite minute"
convert "$Repscan/$Scan.tiff" "$Repscan/$Scan.png"
sleep 2
convert "$Repscan/$Scan.png" -resize 50% "imagereduite.png"
mv "imagereduite.png" "$Repscan/$Scan.png"
sleep 1

echo "Création du fichier $Scan.pdf"
convert "$Repscan/$Scan.tiff" "$Repscan/$Scan.pdf" 2>/dev/null
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
