#!/bin/bash
# Auteur :      Christophe L - pour Aciah
# licence :     GNU General Public Licence v3
# Version 2.0 modifiée par  Aciah juin 2022
# Description : Gesstionnaire de session
# Dépendances : yad, wmctrl -> sudo apt-get install wmctrl


# Variables :
$ICONS0=/usr/share/pixmaps/gnome-shutdown3.png

# Fonctions :


notify(){
  echo "$1""$2""$3"
  stopmbrola
  notify-send -i "" "$1"
  [ "$scr" = "1" ] && espeak -v $TYPE -s $SPEED -p $PITCH "$1 ." | mbrola $VOIX - -.au | aplay 
  sleep "$2"
  
  yad --width=640 --height=250 --center \
  --window-icon "$ICONS0" --image "$ICONS0" \
  --on-top --undecorated \
  --text-align=center \
  --title "$TITLE - $1" \
  --text "<big><big><big>\n\n\n    $1\n</big></big></big>" \
  --timeout="$3" \
  --no-buttons \
  
}

stopmbrola(){
  if [ -n "$(ps -A | grep mbrola)" ] ; then
	killall -KILL mbrola && sleep 2
  fi

}

##### test pour savoir si la lecture est en route #####
#if [ -n "$(ps -A | grep mbrola)" ] ; then
#	killall -KILL mbrola && sleep 2
#fi

##### test et creation dossier ConfigVoix et des fichiers de configurations #####

if [ ! -d $HOME/.local/ConfigVoix/ ] ; then
     mkdir $HOME/.local/ConfigVoix
     # Voix feminine
     TYPE_VOIX=/usr/share/mbrola/fr4/fr4 
     TYPE_V=mb/mb-fr4 
     # Voix masculine
     #TYPE_VOIX=/usr/share/mbrola/fr1/fr1
     #TYPE_V=mb/mb-fr1
     SPEED_V="50"
     PITCH_V="20"
     echo $TYPE_VOIX > $HOME/.local/ConfigVoix/voix.conf
     echo $TYPE_V > $HOME/.local/ConfigVoix/type.conf
     echo $SPEED_V > $HOME/.local/ConfigVoix/speed.conf
     echo $PITCH_V > $HOME/.local/ConfigVoix/pitch.conf
fi


##### choix du type de voix à utiliser #####

VOIX=$(cat $HOME/.local/ConfigVoix/voix.conf)
TYPE=$(cat $HOME/.local/ConfigVoix/type.conf)
SPEED=$(cat $HOME/.local/ConfigVoix/speed.conf)
PITCH=$(cat $HOME/.local/ConfigVoix/pitch.conf)

if pgrep "orca" > /dev/null; then
    scr=1
else
    scr=0
fi

cd $HOME

HM=""

# messages
APPNAME="DECONNEXION of : $USER"
WARN="Make your choice in the list"
TITLE="MENU DECONNEXION "
HMMSG="Your choice?\n$WARN"
CHOICE="selected"
HALT=" POWER OFF "
REBOOT="    REBOOT   "
DECONNECT="    LOGOUT   "
#SLEEP1="  SUSPEND  "
#HIBERNATE=" HIBERNATE "
#USWITCH="USER SWITCH"
TOOLIP1="Power off your computer"
TOOLIP2="Reboot your computer"
TOOLIP3="Logout of current session"
TOOLIP4="Switch to Suspend mode"
TOOLIP5="Switch to Hibernate mode"
TOOLIP6="Switch user" 


case $LANG in
       fr*)
       APPNAME="Menu de DÉCONNEXION"
       WARN="choisissez et validez avec : Entrée"
       TITLE="MENU de DÉCONNEXION "
       HMMSG="Votre choix?\n"
       CHOICE="sélectionné"
       HALT="      ÉTEINDRE      "
       REBOOT="   REDÉMARRER   "
       DECONNECT=" DÉCONNEXION "
       TOOLIP1="Arret de votre ordinateur"
       TOOLIP2="Redémarrage de votre ordinateur"
       TOOLIP3="Déconnexion de votre session actuelle" 
       ;;

esac

### end trads
###### Notification #######

#ICONS=$ICONS0
notify "$TITLE" "2" "1"

yad --form --on-top --columns=3 \
     --window-icon "$ICONS0"  --image "$ICONS0" \
     --title="$TITLE - $WARN" \
     --center --undecorated \
     --text-align=center --text "<big><big>$TITLE\n\n</big>$WARN\n</big>" \
     --field="<big>$HALT</big>!$ICONS1!<big>$TOOLIP1</big>:fbtn" \
     --field="<big>$REBOOT</big>!$ICONS2!<big>$TOOLIP2</big>:fbtn" \
     --button="gtk-cancel:1" \
     "xfce4-session-logout --halt" "xfce4-session-logout --reboot"\


exit 0
