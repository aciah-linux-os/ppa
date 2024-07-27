#!/bin/bash

# Version : 2.1 juillet 2024
# Licence : GPL v3
# Fonction : Paramètrage de la voix espeak
# Maintenance : Christophe L. pour association ACIAH
# Shell : bash
# Paramètres : aucun
# Dépendance : espeak, mbrola, notify-send, yad
# nécessite mbrola fr1, fr2, fr3, fr4 et fr6 qu'on peut installer par synaptic

# Variables :

ICONS="/usr/share/icons/Mint-L/apps/64/espeak.png"

TITLE="Réglages de la voix ESPEAK"

# Fonctions :

notify(){
  echo "$1"
  stopmbrola
  notify-send -i "$ICONS" "$TITLE" "$1"
  espeak -v $TYPE -s $SPEED -p $PITCH "$TITLE : $1 ."
  sleep "$2"
  
  yad --width=640 --height=250 --center \
  --window-icon "$ICONS" --image "$ICONS" \
  --on-top --undecorated \
  --text-align=center \
  --text "<big><big><big>\n$TITLE\n </big>$1 \n\n</big></big>" \
  --timeout="$3" \
  --no-buttons \
  
}


dialog_warning(){
  echo "$1"
  yad --width=450 --height=150 --center --image dialog-warning \
  --window-icon "$ICONS" \
  --on-top --undecorated \
  --title "$TITLE - $1" \
  --text-align=center \
  --text "<big><big>\n$1 \n</big></big>" \
  --button="OUI:0" \
  --button="NON:1" \

  case $? in
        0)  
            return
            ;;
        1)  
            [ "$2" = "1" ] && config_debit
            [ "$2" = "2" ] && config_hauteur
  	    return
	    ;;
  esac
      
}

stopmbrola(){
  if [ -n "$(ps -A | grep mbrola)" ] ; then
	killall -KILL mbrola && sleep 2
  fi

}

config_debit(){
	#notify "Débit de la voix : déplacez le curseur et validez" "3" "3"
	SPEED_V=$(yad --width=640 --height=250 --center --scale --title "$TITLE - RÉGLAGE DU DÉBIT - Votre choix ?" --window-icon "$ICONS" --image=$ICONS --on-top --undecorated --text "<b><big><big>\n$TITLE \n\n </big>RÉGLAGE DU DÉBIT\nVotre choix ?\n</big></b>"  --text-align=center --button="gtk-ok:0" --button="gtk-cancel:1" --value="$SPEED" --min-value="80" --max-value="320" --mark=80:80 --mark=120:120 --mark=160:160 --mark=200:200 --mark=240:240 --mark=280:280 --mark=320:320 --step="5")
        #
	if [ ! -z $SPEED_V ]; then
	echo $SPEED_V > speed.conf
	fi
        #
	SPEED=$(cat $HOME/.local/ConfigVoix/speed.conf)
        notify "Débit réglé à $SPEED mots par minute" "2" "3"
        [ ! -z $SPEED_V ] && dialog_warning "Cela vous convient-il ?" "1"
        
}

config_hauteur(){
	#notify "Hauteur de la voix" "3" "3"
	PITCH_V=$(yad --width=640 --height=250 --center --scale --title "$TITLE - RÉGLAGE DE LA HAUTEUR - Votre choix ?" --window-icon "$ICONS" --image=$ICONS --on-top --undecorated --text "<b><big><big>\n$TITLE \n\n </big>RÉGLAGE DE LA HAUTEUR\nVotre choix ?\n</big></b>"  --text-align=center --button="gtk-ok:0" --button="gtk-cancel:1" --value="$PITCH" --min-value="0" --max-value="100" --mark=0:0 --mark=25:25 --mark=50:50 --mark=75:75 --mark=100:100 --step="1")
        #
	if [ ! -z $PITCH_V ]; then
	echo $PITCH_V > pitch.conf
	fi
        #
	PITCH=$(cat $HOME/.local/ConfigVoix/pitch.conf)
        notify "Hauteur de la voix réglée à $PITCH" "2" "3"
        [ ! -z $PITCH_V ] && dialog_warning "Cela vous convient-il ?" "2"
        
}


##### test et creation dossier ConfigVoix et des fichiers de configurations #####

if [ ! -d $HOME/.local/ConfigVoix/ ] ; then
     mkdir $HOME/.local/ConfigVoix
     # Voix feminine
     TYPE_VOIX=/usr/share/mbrola/fr4/fr4 
     TYPE_V=mb/mb-fr4 
     # Voix masculine
     #TYPE_VOIX=/usr/share/mbrola/fr1/fr1
     #TYPE_V=mb/mb-fr1
     SPEED_V="160"
     PITCH_V="50"
     echo $TYPE_VOIX > $HOME/.local/ConfigVoix/voix.conf
     echo $TYPE_V > $HOME/.local/ConfigVoix/type.conf
     echo $SPEED_V > $HOME/.local/ConfigVoix/speed.conf
     echo $PITCH_V > $HOME/.local/ConfigVoix/pitch.conf
fi

if pgrep "orca" > /dev/null; then
    scr=1
else
    scr=0
fi

cd $HOME/.local/ConfigVoix

##### choix du type de voix à utiliser #####

VOIX=$(cat $HOME/.local/ConfigVoix/voix.conf)
TYPE=$(cat $HOME/.local/ConfigVoix/type.conf)
SPEED=$(cat $HOME/.local/ConfigVoix/speed.conf)
PITCH=$(cat $HOME/.local/ConfigVoix/pitch.conf)


##### Notification #####

notify " " "3" "3"

##### Notification #####

notify "Choix de la voix" "3" "3"

###### Notification #######

notify "Sélectionnez : Voix féminine ou Voix masculine" "3" "3"

TV=$(yad --width=640 --height=250 --center --list --title "$TITLE - VOIX FEMININE ou MASCULINE - Votre choix ?" --window-icon "$ICONS" --image=$ICONS --on-top --undecorated --text "<b><big><big>\n$TITLE \n\n </big>VOIX FEMININE ou MASCULINE\nVotre choix ?\n</big></b>"  --text-align=center --separator="|" --button="gtk-ok:0" --button="gtk-cancel:1" --radiolist --column="      CHOIX     " --column="TYPE DE VOIX" TRUE "<big>Voix féminine</big>" FALSE "<big>Voix masculine</big>")
#
TVE=`echo $TV | cut -d ">" -f2 | cut -d "<" -f1`

if [ "$TVE" = "Voix féminine" ]; then
    TYPE_VOIX=/usr/share/mbrola/fr4/fr4
    TYPE_V=mb/mb-fr4
fi
if [ "$TVE" = "Voix masculine" ]; then
    TYPE_VOIX=/usr/share/mbrola/fr/fr1
    TYPE_V=mb/mb-fr1
fi

##### On change les paramètres en cours #####

if [ "$TVE" != "" ]; then
    echo $TYPE_VOIX > voix.conf
    echo $TYPE_V > type.conf
    #
    VOIX=$(cat $HOME/.local/ConfigVoix/voix.conf)
    TYPE=$(cat $HOME/.local/ConfigVoix/type.conf)
    #
    notify "$TVE sélectionnée" "2" "3"
else
    notify "Voix actuelle conservée" "2" "3"
fi

##################################################

notify "Débit de la voix" "3" "3"

config_debit

##################################################

notify "Hauteur de la voix" "3" "3"

config_hauteur

##################################################

notify "Opération Terminée" "2" "3"

exit 0
