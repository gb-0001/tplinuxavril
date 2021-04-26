#!/bin/bash
#script de pour simuler les fonctionnements d'une corbeille

#création de chemin de la corbeille dans le home de l'utilisateur
PATHCORBEILLE=~/corbeille
RESTOREFILE=$PATHCORBEILLE/nomdufichier.info
#Test l'existance du dossier et du fichier pour la restauration
if [ ! -d "$PATHCORBEILLE" ]; then
    mkdir $PATHCORBEILLE
elif [ ! -f "$RESTOREFILE" ]; then
    touch $RESTOREFILE
fi

CPTLIGNE=1

if [[ $# = 0 ]]; then
    echo ""
    echo "HELP:"
    echo ""
    echo "- Faire /bin/bash corbeille.sh RM FILENAME pour déplacer les fichiers dans $PATHCORBEILLE"
    echo "- Faire corbeille.sh TRASH FILENAME pour lister le contenu des fichiers dans $PATHCORBEILLE"
    echo "- Faire corbeille.sh RESTORE FILENAME pour restaurer depuis $PATHCORBEILLE un fichier de la corbeille vers son emplacement original"
    exit 0
#Test des arguments
elif [[ $1 = "RM" ]] || [[ $1 = "TRASH" ]] || [[ $1 = "RESTORE" ]]; then
    if [[ $1 = "RM" ]]; then
        #TEST si le fichier existe
        if [[ -f $2 ]]; then
            CURRENTPATH=$(readlink -f $2 )
            mv $2 $PATHCORBEILLE/$2
            echo "$CURRENTPATH" >> $PATHCORBEILLE/nomdufichier.info
        else
            echo "Le fichier n'existe pas"
            exit 0
        fi
    elif [[ $1 = "TRASH" ]]; then
        #lit le fichier et compte les lignes et affiche
        while read LINE; do
            echo "$CPTLIGNE - $LINE"
            CPTLIGNE=$((CPTLIGNE+1))
        done < $PATHCORBEILLE/nomdufichier.info
    elif [[ $1 = "RESTORE" ]]; then
    # test si la saisi est un numerique
        read -p "Saisir le numero de ligne à restaurer:" NUMLINE
        NUMLINE=$((NUMLINE))
        TESTNUM='^[0-9]+$'
        if [[ $NUMLINE =~ $TESTNUM ]]; then
            RESTOREPATHTMP=`sed -n "$NUMLINE p" $PATHCORBEILLE/nomdufichier.info`
            FILENAMERESTORE=$(basename "$RESTOREPATHTMP")
            mv $PATHCORBEILLE/$FILENAMERESTORE $RESTOREPATHTMP
            sed "${NUMLINE}d" $PATHCORBEILLE/nomdufichier.info
        else
            echo "Ce n'est pas un numero de ligne valide"
            exit 0
        fi
    fi
else
    echo "Paramètre non valide choix possible RM, TRASH ou RESTORE"
fi
