#!/bin/bash
# Script que da de alta las UOs indicados en fichero csv
#ejecutamos el script pasándole como parámetro el nombre del fichero con los datos de las UOs



while IFS=* read -r col1 col2 col3
do
        echo "I got:$col1"
        # Extraemos los campos de las UOs
        NAME=$col1
        DESCRIPTION=$col2
        PATH=$col3

        echo "Añadiendo UO $NAME..."
        #Añade la UO correspondiente
	/usr/bin/samba-tool ou create $PATH --description="$DESCRIPTION"
        echo "[UO $NAME creado correctamente]"

done <  $1
