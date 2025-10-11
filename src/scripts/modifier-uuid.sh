#!/usr/bin/env bash
# VERSION 1
# AUTHOR  association ACIAH, octobre 2025
# Licence : GPL V3
# Modifications : 
# Ce script montre les partitions ext4 disponibles, demande laquelle on veut modifier,
# démonte, vérifie, change l’UUID, met à jour fstab, initramfs et grub,
# puis démonte tout proprement.
# il faut disposer d'une clé live-system installée avec linux-mint ou lubuntu - sur laquelle on copie ce script avec les droits nécessaires.
# utilisation : sudo bash modifier-uuid.sh


 set -euo pipefail

# Nom : changer-uuid-du-disque-clone.sh
# Script interactif pour changer l'UUID d'une partition ext4 (Linux Mint / Ubuntu)
# Accepte un numéro OU un nom de partition en entrée.

TIMESTAMP=$(date +%Y%m%d-%H%M%S)
TARGET_MNT="/mnt/target"

echo "=== Script de changement d'UUID (version tolérante) ==="

# Vérifier que l'on est root
if [ "$(id -u)" -ne 0 ]; then
  echo "ERREUR : ce script doit être exécuté en root (sudo)." >&2
  exit 1
fi

# Détecter les partitions ext4 disponibles
echo "Recherche des partitions ext4 disponibles..."
mapfile -t EXT4_PARTS < <(lsblk -ln -o NAME,FSTYPE | awk '$2=="ext4"{print "/dev/"$1}')

if [ ${#EXT4_PARTS[@]} -eq 0 ]; then
  echo "Aucune partition ext4 trouvée."
  exit 2
fi

echo "Partitions ext4 détectées :"
i=1
for p in "${EXT4_PARTS[@]}"; do
  echo "  $i) $p"
  ((i++))
done

# Lecture de la sélection
read -rp "Choisir le numéro OU le nom de la partition à modifier : " choice

# Déterminer le périphérique sélectionné
selected=""
if [[ "$choice" =~ ^[0-9]+$ ]]; then
  # choix numérique
  selected="${EXT4_PARTS[$((choice-1))]:-}"
elif [[ "$choice" =~ ^/dev/ ]]; then
  selected="$choice"
else
  # peut-être juste "sda3"
  selected="/dev/$choice"
fi

# Vérifier que la partition existe
if [ ! -b "$selected" ]; then
  echo "ERREUR : la partition $selected n'existe pas."
  exit 3
fi

echo "Partition choisie : $selected"

# Confirmation de sécurité
read -rp "⚠️ Etes-vous sûr de vouloir changer l’UUID de $selected ? (o/n) : " confirm
if [[ ! "$confirm" =~ ^[oOyY]$ ]]; then
  echo "Opération annulée."
  exit 0
fi

# Si montée, démonter
if mount | grep -q "$selected"; then
  echo "Démontage de $selected..."
  umount "$selected" || { echo "Impossible de démonter $selected"; exit 4; }
fi

# Vérifier le système de fichiers
echo "Vérification du système de fichiers (e2fsck)..."
e2fsck -f -y "$selected"

# Nouveau UUID
new_uuid=$(uuidgen)
echo "Nouvel UUID généré : $new_uuid"

# Appliquer
echo "Application du nouvel UUID..."
tune2fs -U "$new_uuid" "$selected"

# Vérification
cur_uuid=$(blkid -s UUID -o value "$selected")
echo "UUID après modification : $cur_uuid"

# Monter la partition
echo "Montage sur $TARGET_MNT..."
mkdir -p "$TARGET_MNT"
mount "$selected" "$TARGET_MNT"

# Sauvegarder et modifier fstab
if [ -f "$TARGET_MNT/etc/fstab" ]; then
  cp "$TARGET_MNT/etc/fstab" "$TARGET_MNT/etc/fstab.bak.$TIMESTAMP"
  echo "Sauvegarde du fstab : /etc/fstab.bak.$TIMESTAMP"

  old_uuid=$(grep -oP '(?<=UUID=)[0-9a-fA-F-]+' "$TARGET_MNT/etc/fstab" | head -n1 || true)

  if [ -n "$old_uuid" ]; then
    sed -i "s/$old_uuid/$new_uuid/g" "$TARGET_MNT/etc/fstab"
    echo "fstab mis à jour avec le nouvel UUID."
  else
    echo "Aucun ancien UUID trouvé dans fstab — vérifie manuellement si besoin."
  fi
else
  echo "ATTENTION : aucun fstab trouvé sur la partition montée."
fi

# Préparation du chroot
echo "Préparation du chroot pour mise à jour grub/initramfs..."
for fs in /dev /dev/pts /proc /sys /run; do
  mount --bind "$fs" "$TARGET_MNT$fs"
done

# Mise à jour système
echo "Mise à jour dans le chroot..."
chroot "$TARGET_MNT" /bin/bash -c "
  set -e
  echo '→ update-initramfs...'
  if command -v update-initramfs >/dev/null; then
    update-initramfs -u
  fi
  echo '→ update-grub...'
  if command -v update-grub >/dev/null; then
    update-grub
  fi
"

# Nettoyage
echo "Nettoyage..."
for fs in /run /sys /proc /dev/pts /dev; do
  umount -l "$TARGET_MNT$fs" 2>/dev/null || true
done
umount "$TARGET_MNT" || true
rmdir "$TARGET_MNT" 2>/dev/null || true

echo
echo "=== ✅ Terminé avec succès ==="
echo "Partition : $selected"
echo "Nouvel UUID : $new_uuid"
echo "fstab sauvegardé sous : /etc/fstab.bak.$TIMESTAMP"
echo "Vous pouvez maintenant redémarrer."
