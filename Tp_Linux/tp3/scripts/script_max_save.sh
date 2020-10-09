#!/bin/bash
# Nicolas Dayot
# 09/10/2020
# script de suppression des saves anciennes

#répertoire de sauvegarde
REP_SAVE="/srv/save"


#plus vieille sauvegarde
OLD_F=$(ls -t "${REP_SAVE}" | tail -1)

check(){
        find "${REP_SAVE}" -maxdepth 1 -type f | wc -l | awk '{print $1}'
}

#nombre de sauvegardes précédentes
NBR_SAVE=$(check)

#limite du nombre de sauvegardes
LIMIT="8"

if [ "$NBR_SAVE" -lt "$LIMIT" ]
 then
	echo "Nombre de sauvegardes limité"
else
	rm  "${REP_SAVE}/${OLD_F}"
	echo "suppression des anciennes sauvegardes"
fi