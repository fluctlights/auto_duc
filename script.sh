#!/bin/bash

# ------------------ Variables globales ------------------ #

USUARIO="" #email
PASS=""
HOST=""
IP=""
WEB="@dynupdate.no-ip.com/nic/update?"

# ------------------ Metodos ------------------ #

function recoger_args
{
    if [ $@ -ne 4 ]; then     # si no tenemos los argumentos necesarios salimos
        echo "ERROR! Uso: ./script.sh '<usuario>' '<password>' '<host>'"
        exit -1
    fi

    USUARIO="${USUARIO}$1" 
    PASS="${PASS}$2"
    HOST="${HOST}$3"
}

function obtener_ip
{
    IP=$(wget -qO- "http://myexternalip.com/raw") #obtencion de IP publica

    if [ $IP -eqz ]; #error al obtener IP
    then
        echo "NO se ha podido obtener la IP! Saliendo ..."
        exit -1
    fi
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

    RES=$(curl -k -u "http://${AUTH}${WEB}hostname=${HOST}&ip=${IP}")

    if [ $RES -ne 200 ];
    then
        echo "Problema al actualizar"
    fi
}

# ------------------ ToDo ------------------ #

recoger_args
obtener_ip
realizar_peticion
# realizar_peticion_bash



