#!/bin/bash
# # VERSION 2.0
# AUTHOR : association ACIAH
# Licence : GPL V3
# Modifications : Gérard Ruau (membre association ACIAH), 12/05/2024
# NAME : dezip.sh 
# DESCRIPTION : script pour décompresser une archive en utilisant la touche F10
# RACCOURCIS : ce script est placé dans le dossier $HOME/.config/caja/scripts
# et est appelé par le raccourci : F10 dans Caja.

# Émettre un bip sonore
aplay /usr/local/share/advl/beep.wav

# Vérification de la présence d'un argument
if [ -z "$1" ]; then
    echo "Usage: $0 archive"
    exit 1
fi

# Définition des variables
FILE="$1"
ZIPDIR="$HOME/Dossier-dezip"

# Création du dossier de destination s'il n'existe pas
mkdir -p "$ZIPDIR"

# Copie de l'archive dans le dossier de destination
cp "$FILE" "$ZIPDIR"

# Renommage des fichiers pour remplacer les espaces par des underscores
cd "$ZIPDIR"
for file in *; do
    if [[ "$file" == *" "* ]]; then
        mv "$file" "${file// /_}"
    fi
done

# Détermination de l'archive à traiter (après renommage)
ARCHIVE=$(ls | grep -E '\.(zip|tar\.gz|tar\.bz2)$')
FILENAME="$(basename "$ARCHIVE")"
EXTENSION="${FILENAME##*.}"

# Extraction selon l'extension
case "$FILENAME" in
    *.zip)
        DOSSIER="${FILENAME%.zip}"
        mkdir -p "$DOSSIER"
        unzip -o "$FILENAME" -d "$DOSSIER"
        rm -f "$FILENAME"
        ;;
    *.tar.gz)
        DOSSIER="${FILENAME%.tar.gz}"
        mkdir -p "$DOSSIER"
        tar -xzf "$FILENAME" -C "$DOSSIER"
        rm -f "$FILENAME"
        ;;
    *.tar.bz2)
        DOSSIER="${FILENAME%.tar.bz2}"
        mkdir -p "$DOSSIER"
        tar -xjf "$FILENAME" -C "$DOSSIER"
        rm -f "$FILENAME"
        ;;
    *)
        # Pour les autres types, ouverture dans xarchiver
        xarchiver --extract-to="$ZIPDIR" "$FILENAME"
        rm -f "$FILENAME"
        ;;
esac

sleep 3

# Message vocal
espeak -a 300 -v mb-fr1 -s 150 "le document ob tenu est dans le dossier dezip"
espeak -a 300 -v mb-fr1 -s 150 "le dossier dezip va s'ouvrir"

# Ouverture du dossier
caja "$ZIPDIR"

# Bip de fin
aplay /usr/local/share/advl/beep.wav
aplay /usr/local/share/advl/beep.wav
