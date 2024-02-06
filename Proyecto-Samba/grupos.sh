#!/bin/bash
# Script que da de alta los grupos indicados en fichero csv
#ejecutamos el script pasándole como parámetro el nombre del fichero con los datos de los grupos


while IFS=* read -r col1 col2 col3 col4 col5
do
    echo "I got:$col1|$col3|$col4"
        # Extraemos los campos de los grupos
        NAME=$col1
        PATH=$col2
        TYPE=$col3
        SCOPE=$col4
	USERS=$col5
	#Añadimos el grupo
        echo "Añadiendo grupo $NAME..."
        #Añade el grupo en la UO correspondiente
        /usr/bin/samba-tool group add $NAME --groupou=$PATH --group-type=$TYPE --group-scope=$SCOPE
        echo "[Grupo $NAME creado correctamente]"
	#Añadir usuarios a los grupos recien creados
	/usr/bin/samba-tool group addmembers $NAME $USERS
    
done <  $1
