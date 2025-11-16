#!/bin/sh

# VERSION :     1.0
# AUTHOR:	(c) Christophe L et ACIAH - novembre 2025
# DESCRIPTION:	Script pour convertir des fichiers PDF en fichiers JPG avec une résolution de 300 dpi

# Tous les fichiers pdf sont convertis en fichiers jpg individuels
# Requires "pdftoppm" package.
# 
#
OLDIFS=$IFS
IFS="
"
for filename in $@; do
pdftoppm -jpeg -r 300 "$filename" "${filename%\.*}_page"
done
IFS=$OLDIFS
