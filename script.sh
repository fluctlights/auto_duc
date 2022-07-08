#!/bin/bash

# ------------------ Variables globales -------------------- #

EMAIL=""
PASS=""
DOMINIO=""
IP=""
WEB="dynupdate.no-ip.com/nic/update"

# ---------------------- Funciones ------------------------- #

function recoger_args
{
    if [ $@ -ne 4 ]; then     # si no tenemos los argumentos necesarios salimos
        echo "ERROR! Uso: ./script.sh '<email>' '<contrasena>' '<dominio>'"
        exit -1
    fi

    EMAIL="${EMAIL}$1" 
    PASS="${PASS}$2"
    DOMINIO="${DOMINIO}$3"
}

function obtener_ip
{
    IP=$(curl ifconfig.me) #obtencion de IP publica
    IP_2=$(curl https://ipinfo.io/ip) # variante

    if [ -z "$IP" ]; # campo IP vacio
    then
        echo "ERROR! No se ha podido obtener la IP! Saliendo ..."
        exit -1
    fi
}

function realizar_peticion
{
    AGENTE="bash-curl-cron/1.0 youremail@yourdomain.com" # necesario, sin el corremos riesgo de que la peticion se bloquee
    COMANDO="curl --user-agent $AGENTE --silent https://$USUARIO:$PASS@$WEB?hostname=${HOST}&myip=${IP}"
    echo "Realizando peticion"
    RESULTADO=$(curl $COMANDO)
    echo $RESULTADO
}

# ----------------------- ToDo ----------------------- #

recoger_args
obtener_ip
realizar_peticion
