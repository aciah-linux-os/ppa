#!/usr/bin/env python3
# VERSION 1.0
# Auteur : association ACIAH - juillet 2025
# Licence : GPL - v3
# Modifications :
# Nom : agenda
# DESCRIPTION : lister les événements à venir
# DEPENDANCES : le script nécessite python 3
# COMPLEMENTS : nécessite le fichier /usr/local/bin/agenda.json
# RACCOURCIS : ce script est placé dans le dossier /usr/local/bin
# 


import json
from datetime import datetime

AGENDA_FILE = '/usr/local/bin/agenda.json'
# on peut choisir ici un autre emplacement pour agenda.json
def charger_agenda():
    try:
        with open(AGENDA_FILE, 'r') as f:
            return json.load(f)
    except (FileNotFoundError, json.JSONDecodeError):
        return []

def nettoie_agenda(agenda):
    now = datetime.now()
    return [
        rv for rv in agenda
        if datetime.strptime(rv['date'] + ' ' + rv['heure'], '%d/%m/%Y %H:%M') >= now
    ]

def sauvegarder_agenda(agenda):
    # Nettoyage AVANT sauvegarde
    agenda_nettoye = nettoie_agenda(agenda)
    agenda_trie = sorted(
        agenda_nettoye,
        key=lambda rv: datetime.strptime(rv['date'] + ' ' + rv['heure'], '%d/%m/%Y %H:%M')
    )
    with open(AGENDA_FILE, 'w') as f:
        json.dump(agenda_trie, f, ensure_ascii=False, indent=2)

def ajouter_rendez_vous(agenda):
    print("Ajout d'un nouveau rendez-vous")
    date_str = input('Date (JJ/MM/AAAA) : ')
    heure_str = input('Heure (HH:MM) : ')
    motif = input('Motif : ')
    try:
        date = datetime.strptime(date_str + ' ' + heure_str, '%d/%m/%Y %H:%M')
        agenda.append({'date': date.strftime('%d/%m/%Y'), 'heure': date.strftime('%H:%M'), 'motif': motif})
        sauvegarder_agenda(agenda)
        print("Rendez-vous ajouté avec succès.")
    except ValueError:
        print("Format de date ou d'heure invalide.")

def lister_rendez_vous(agenda):
    agenda_a_venir = nettoie_agenda(agenda)

    if not agenda_a_venir:
        print("Aucun rendez-vous à venir.")
        return

    agenda_trie = sorted(
        agenda_a_venir,
        key=lambda rv: datetime.strptime(rv['date'] + ' ' + rv['heure'], '%d/%m/%Y %H:%M')
    )

    for rv in agenda_trie:
        print(f"{rv['date']} à {rv['heure']} : {rv['motif']}")

def menu():
    agenda = charger_agenda()
    # Nettoie dès le chargement et sauvegarde
    agenda = nettoie_agenda(agenda)
    sauvegarder_agenda(agenda)

    while True:
        print("\n1. Ajouter un rendez-vous")
        print("2. Lister les rendez-vous")
        print("3. Quitter")
        choix = input("Tapez [1] ou Entrée : ").strip()
        if choix == "" or choix == "1":
            ajouter_rendez_vous(agenda)
            agenda = charger_agenda()  # pour re-synchroniser après ajout
        elif choix == "2":
            lister_rendez_vous(agenda)
        elif choix == "3":
            break
        else:
            print("Choix inconnu.")

if __name__ == "__main__":
    menu()
