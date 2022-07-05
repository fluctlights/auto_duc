#!/bin/bash

# ------------------------- Variables globales ----------------------- #

USUARIO="" # email!!
PASS=""
HOST="" # nombre del dominio que queremos actualizar
IP="" # direccion IP la cual el dominio nos referenciara
URL_REQUEST="" # url sobre la que realizaremos la peticion

WEB="https://dynupdate.no-ip.com/nic/update?"
USERAGENT="--user-agent 'no-ip shell script/1.0 mail@mail.com'" #atributo para cURL

# ---------------------------- Metodos ------------------------------ #

function obtener_credenciales
{
    
    # Nota : para hacerlo automatico (uso con cron) borrar el condicional 
    #         y poner los valores concretos directamente justo debajo
    
    if [ $@ -ne 4 ]; then     # si no tenemos los argumentos necesarios salimos
        echo "ERROR!! Uso: ./script.sh '<usuario>' '<password>' '<host_para_actualizar>'"
        exit -1
    fi

    USUARIO="$1" 
    PASS="$2"

    # Ciframos las credenciales
    BASE64_PASS=$(echo "$USUARIO:$PASS" | base64)
    AUTH_HEADERS="\"Authorization: Basic ${BASE64_PASS}"\" #parametro para cURL

}

function obtener_datos_host-ip
{
    HOST="hostname=$3"
    
    IP=$(wget -qO- "http://myexternalip.com/raw") # obtencion de IP publica

    if [ $IP -eqz ]; # error al obtener IP
    then
        echo "NO se ha podido obtener la IP! Saliendo ..."
        exit -1
    fi

    # Actualizamos los datos de la URL
    URL_REQUEST="${WEB}${HOST}&ip=${IP}"
}

function realizar_peticion { python3 -c "
    
import requests
import sys
url = 'http://${AUTH}${WEB}hostname=${HOST}&ip=${IP}'
r = requests.get(url)
if r.status_code != 200:
    print('Error al realizar la peticion! Saliendo...')
    sys.exit(1)
else:
    print('Hostname actualizado correctamente')
";
}

function realizar_peticion_bash { 

    CMD=$(curl -X GET ${URL_REQUEST} -H ${AUTH_HEADERS})

    # Comprobacion de errores
    RESULT=$(eval ${CMD})

	if [ -z "$RESULT" ] && [ $? -ne 0 ]
        echo "Problema al actualizar el host"
    fi
}

# -------------------------------- ToDo -------------------------------- #

recoger_args
obtener_ip
realizar_peticion
# realizar_peticion_bash
