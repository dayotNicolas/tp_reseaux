#!/bin/bash
# Nicolas Dayot
# 08/10/2020
# Script de vérification avant sauvegarde

REP_SAVE="/srv/save"

# vérification de l'existance des dossiers

if [[ ! -d "${REP_SAVE}" ]]
then
        echo "No save directory existing" >&2
        exit 1
else
	echo "repo check ok!"
fi