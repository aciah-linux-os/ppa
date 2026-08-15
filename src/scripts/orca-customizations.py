#!/usr/bin/env python3
# ce script est utilisé pour l'outil : parle
# VERSION 1.0
# Auteur : Mickaël et association ACIAH
# Licence : GPL - v3
# Date : 15 aout 2026 :
# DESCRIPTION : 
# DEPENDANCES : le script nécessite le paquet python3
# COMPLEMENTS :  
# RACCOURCIS : ce script est placé dans le dossier /home/USER/.local/share/orca

import sys
import subprocess

def speak(text, lang="fr_FR", rate="-30"):
    try:
        subprocess.run(
            ["spd-say", "--wait", "-l", lang, "-r", str(rate), text],
            check=True
        )
    except Exception as e:
        print(f"Erreur lors de la synthèse vocale : {e}", file=sys.stderr)
        sys.exit(1)

if __name__ == "__main__":
    if len(sys.argv) < 4:
        print("Usage: python3 orca-customizations.py LANG RATE TEXTE", file=sys.stderr)
        sys.exit(1)

    lang = sys.argv[1].strip() or "fr_FR"
    rate = sys.argv[2].strip() or "-30"
    texte = " ".join(sys.argv[3:]).strip()

    if not texte:
        print("Erreur : texte vide.", file=sys.stderr)
        sys.exit(1)

    speak(texte, lang, rate)
