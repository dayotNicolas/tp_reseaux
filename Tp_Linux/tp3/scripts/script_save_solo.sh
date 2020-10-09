#!/bin/bash
# Nicolas Dayot
# 09/10/2020
# script de sauvegarde de site1 et site2 

echo $$ > /var/run/backup/tp3.pid

# répertoire de sauvegarde
REP_SAVE="/srv/save"

#répertoires à sauvegarder
REP_SITE1="/srv/site1"
REP_SITE2="/srv/site2"

#noms des sites

SITE1=${REP_SITE1:5}
SITE2=${REP_SITE2:5}

#récupération de la date
DATE=$(date +%Y%m%d%H%M)

#noms des archives

NAME_TAR1=${SITE1}_${DATE}
NAME_TAR2=${SITE2}_${DATE}

save(){
        tar zcvf "${REP_SAVE}/${NAME_TAR1}.tar.gz" "${SITE1}"
	tar zcvf "${REP_SAVE}/${NAME_TAR2}.tar.gz" "${SITE2}"
}

save