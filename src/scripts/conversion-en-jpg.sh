#!/bin/sh

# VERSION :     1.0
# AUTHOR:	(c) Christophe L pour ACIAH
# DESCRIPTION:	Script pour convertir des fichiers PDF en fichiers JPG avec une résolution de 300 dpi

# Tous les fichiers IMAGE (par ex. bmp, jpg, png) et TXT ainsi que les fichiers PDF sont convertis en fichiers JPG individuels, 
# tandis que certains fichiers document (par ex. doc, odt) sont convertis en fichiers PDF individuels 
# et enregistrés dans un sous-dossier nommé "_dirname".
# Requires "imagemagick" package which includes "convert"
# 
#
OLDIFS=$IFS
IFS="
"
for filename in $@; do
convert -density 300 "$filename" "${filename%\.*}.jpg"
done
IFS=$OLDIFS
