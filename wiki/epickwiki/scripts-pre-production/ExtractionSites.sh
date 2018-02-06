#!/bin/sh
CONFIG_FILE="/mnt/fs/Sites-actifs.conf"
ARCHIVE_FOLDER="/mnt/fs/Sites"
DOCUMENTS_ROOTS="/var/www/gen"

IFS="
"
echo "Extractions des projets actifs de $CONFIG_FILE dans $DOCUMENTS_ROOTS"
echo "Nettoyage du fichiers de $DOCUMENTS_ROOTS"
rm -Rf ${DOCUMENTS_ROOTS}/*
echo "Le contenu de ce dossier est généré automatiquement
en fonction des projets sauvegardés sur le serveur
de fichiers.

Toute modification sur son contenu sera perdu au prochain
déploiement.

Dernier déploiement le $(date)

Sites déployés : " > ${DOCUMENTS_ROOTS}/README
SITES=$(egrep "^[^#].*\s+.+$" $CONFIG_FILE)

for SITE in $SITES; do
        SITE_NAME=$(echo $SITE | tr -s "	" | cut -f1)
        SITE_STATE=$(echo $SITE | tr -s "	" | cut -f2)
        case $SITE_STATE in
                "ACTIF"|"PARTAGE")
                        echo "Deploiement de $SITE_NAME"
                        if [ -e "${ARCHIVE_FOLDER}/${SITE_NAME}.7z" ]; then
                        	mkdir "${DOCUMENTS_ROOTS}/${SITE_NAME}"
                        	7z x "${ARCHIVE_FOLDER}/${SITE_NAME}.7z" -o"${DOCUMENTS_ROOTS}/${SITE_NAME}"
                        	echo "Site $SITE_NAME deploye"
							echo "- ${SITE_NAME}" >> ${DOCUMENTS_ROOTS}/README
                        else
                        	echo "$SITE_NAME : L'archive ${SITE_NAME}.7z n'existe pas"
                        fi
                        ;;
                "INACTIF")
                        echo "$SITE_NAME ignore"
                        ;;
                *)
                        echo "$SITE_NAME : Etat inconnu $SITE_STATE"
                        ;;
        esac
done
