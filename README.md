# aut_duc.sh

-----------------------------------------------------------------------------
 Herramienta para actualizar de forma automática cualquier hostname de NO-IP
-----------------------------------------------------------------------------

*Esta herramienta es funcional*

Para poder usar el script será necesario dar permisos:

    chmod +x script.sh

Luego habrá de ejecutarse dicho script de la siguiente forma:

    bash script.sh 'tu_usuario_noip' 'password_noip' 'host_para_actualizar'

NOTA: el usuario de NO-IP corresponde al email

La idea de este script es, mediante el uso de Crontab, realizar actualizaciones
periódicas del host automáticamente. Para ello será necesario definir en dicha 
tarea la ejecución del script.
