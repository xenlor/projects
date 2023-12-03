#!/bin/bash

#===========================================================================#
#                           PRACTICA SCRIPTING 3                            #
#  Esteban Castillo Loren - 2ºASIR - Administración de Sistemas Operativos  # 
#===========================================================================#

clear

# Colores para resaltar mensajes en la salida
rojo='\033[0;31m'
verde='\033[0;32m'
amarillo='\033[0;33m'
cyan='\033[0;36m'
reset='\033[0m'

# Funciones

# Verifica si se proporciona el número correcto de argumentos
compruebaArgumentos(){
    if [ $1 -ne 1 ];then
        echo -e "$rojo----------------------------------------------------------$reset"
        echo "ERROR. Debes ingresar el nombre del archivo."
        echo -e "$rojo----------------------------------------------------------$reset"
        exit 1
    fi
}

# Verifica si el archivo de entrada es un fichero regular y existe
compruebaArchivo(){
    if [ ! -f $1 ];then
        echo -e "$rojo----------------------------------------------------------$reset"
        echo "No es un fichero regular o no existe."
        echo -e "$rojo----------------------------------------------------------$reset"
        exit 2
    fi
}

# Crea usuarios para un grupo específico
creaUsuario(){
    for ((i=1;i<=$1;i=i+1));do
        nuevoUser="$2-$i"
        
        # Elimina el usuario existente junto con su directorio home
        if cat /etc/passwd | grep -e "^$nuevoUser:" &>/dev/null ;then
            sudo userdel -r "$nuevoUser" &>/dev/null
            echo -e "$rojo----------------------------------------------------------$reset"
            echo "Usuario $nuevoUser eliminado junto a su directorio home."
            echo -e "$rojo----------------------------------------------------------$reset"
        fi

        # Crea un nuevo usuario y lo agrega al grupo correspondiente
        sudo useradd "$nuevoUser" -g "$2" &> /dev/null
        echo -e "$verde----------------------------------------------------------$reset"
        echo "Se ha creado el usuario '$nuevoUser'"
        echo -e "$verde----------------------------------------------------------$reset"
    done
}

# Crea un grupo si no existe
creaGrupo(){
    if ! cat /etc/group | grep -e "^$1:" &>/dev/null;then
        sudo groupadd "$1"
        echo -e "$cyan----------------------------------------------------------$reset"
        echo "Se ha creado el grupo $1"
        echo -e "$cyan----------------------------------------------------------$reset"
    fi
}

# Ejecución de funciones

# Verifica la cantidad de argumentos proporcionados al script
compruebaArgumentos $#

# Verifica si el archivo de entrada es válido
compruebaArchivo $1

# Procesa cada línea del archivo de entrada
while read linea;do
    grupo=$(echo $linea | cut -d ':' -f 1)
    usuario=$(echo $linea | cut -d ':' -f 2)

    # Crea el grupo si no existe
    creaGrupo $grupo

    # Crea usuarios para el grupo
    creaUsuario $usuario $grupo

done < $1 # Lee las líneas del archivo ingresado ($1)
