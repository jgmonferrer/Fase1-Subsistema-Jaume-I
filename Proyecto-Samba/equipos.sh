#!/bin/bash
# Script que da de alta los equipos indicados en fichero csv
#ejecutamos el script pasándole como parámetro el nombre del fichero con los datos de los equipos
while IFS=* read -r col1 col2
do
    echo "I got:$col1|$col2"
        # Extraemos los campos de los equipos
        NAME=$col1
        PATH=$col2
	#Añadimos el equipo
        echo -n "Añadiendo equipo $NAME"
        #Añade el equipo en la UO correspondiente
	/usr/bin/samba-tool computer create $NAME --computerou=$PATH
        echo "[Equipo $NAME creado correctamente]"
    
done <  $1
