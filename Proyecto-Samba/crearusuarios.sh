#!/bin/bash
# Script que da de alta los usuarios indicados en fichero csv
#ejecutamos el script pasándole como parámetro el nombre del fichero con los datos de los usuarios
#Ejemplo de uso: crear_Usuarios.sh usuarios.csv


while IFS=* read -r col1 col2 col3 col4 col5 col6 col7 col8 col9 col10 col11 col12 col13
do
    echo "I got:$col1|$col2"
        # Extraemos los campos de los usuarios
        NAME=$col1
        SURNAME=$col2
        SURNAME1=$col3
        SURNAME2=$col4
        ACCOUNT=$col5
        DNI=$col6
	DEPARTAMENT=$col7
	PASSWORD=$col8
	EMAIL=$col9
	COMPUTER=$col10
	PATH=$col11
	LOGINSHELL=$col12
	HOMEDIRECTORY=$col13

        # Añadimos el usuario con samba-tool y lo añadimos a la Unidad Organizativa grupo que le corresponde
        echo -n "Añadiendo usuario $ACCOUNT..."
        #Añade el usuario en la UO correspondiente
        /usr/bin/samba-tool user create $ACCOUNT $PASSWORD --must-change-at-next-login --userou=$PATH --home-directory=$HOMEDIRECTORY --given-name="$NAME" --surname="$SURNAME" --mail=$EMAIL --department="$DEPARTAMENT" --login-shell=$LOGINSHELL
	echo "[Usuario $ACCOUNT creado correctamente]"
    
done <  $1
