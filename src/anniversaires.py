#!/usr/bin/env python3
# VERSION 1.0
# Auteur : association ACIAH - juillet 2025
# Licence : GPL - v3
# Modifications :
# Nom : anniversaires
# DESCRIPTION : lister les anniversaires
# DEPENDANCES : le script nécessite python 3
# COMPLEMENTS : nécessite le fichier /usr/local/bin/agenda.json
# RACCOURCIS : ce script est placé dans le dossier /usr/local/bin
# 

import json

FILENAME = '/usr/local/share/advl/anniversaires.json'
# on peut choisir un autre emplacement pour anniversaires.json

def charger_anniversaires():
    try:
        with open(FILENAME, 'r', encoding='utf-8') as f:
            return json.load(f)
    except (FileNotFoundError, json.JSONDecodeError):
        return []

def enregistrer_anniversaires(anniversaires):
    with open(FILENAME, 'w', encoding='utf-8') as f:
        json.dump(anniversaires, f, indent=2, ensure_ascii=False)

def ajouter_anniversaire():
    while True:
        try:
            mois = int(input("Entrez le mois de naissance (1-12) : "))
            if 1 <= mois <= 12:
                break
            print("Veuillez entrer un mois entre 1 et 12.")
        except ValueError:
            print("Veuillez entrer un nombre entier.")
    while True:
        try:
            jour = int(input("Entrez le jour de naissance (1-31) : "))
            if 1 <= jour <= 31:
                break
            print("Veuillez entrer un jour entre 1 et 31.")
        except ValueError:
            print("Veuillez entrer un nombre entier.")
    nom = input("Entrez le nom de la personne : ").strip()
    anniversaires = charger_anniversaires()
    anniversaires.append({'mois': mois, 'jour': jour, 'nom': nom})
    # Tri la liste avant de l'enregistrer pour garder le fichier ordonné
    anniversaires = sorted(
        anniversaires,
        key=lambda x: (int(x['mois']), int(x['jour']))
    )
    enregistrer_anniversaires(anniversaires)
    print(f"Anniversaire de {nom} ajouté pour le {jour:02d}/{mois:02d}.")

def afficher_anniversaires():
    anniversaires = charger_anniversaires()
    if not anniversaires:
        print("Aucun anniversaire enregistré.")
        return
    # Le fichier est déjà trié, cet appel n'est plus indispensable mais on peut le garder par sécurité
    anniversaires_tries = sorted(
        anniversaires,
        key=lambda x: (int(x['mois']), int(x['jour']))
    )
    print("Liste des anniversaires :")
    for anniv in anniversaires_tries:
        print(f"- {anniv['nom']} : {int(anniv['jour']):02d}/{int(anniv['mois']):02d}")

if __name__ == "__main__":
    while True:
        print("\nQue voulez-vous faire ?")
        print("1 - Ajouter un anniversaire")
        print("2 - Afficher la liste des anniversaires")
        print("3 - Quitter")
        choix = input("Votre choix : ").strip()
        if choix == '1':
            ajouter_anniversaire()
        elif choix == '2':
            afficher_anniversaires()
        elif choix == '3':
            print("Au revoir !")
            break
        else:
            print("Choix invalide, veuillez réessayer.")
