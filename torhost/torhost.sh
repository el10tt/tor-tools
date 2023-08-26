#!/bin/bash

banner(){
    echo "
███████               █    █                 █   
   █                  █    █                 █   
   █     ███    █▒██▒ █    █  ███   ▒███▒  █████ 
   █    █▓ ▓█   ██  █ █    █ █▓ ▓█  █▒ ░█    █   
   █    █   █   █     ██████ █   █  █▒░      █   
   █    █   █   █     █    █ █   █  ░███▒    █   
   █    █   █   █     █    █ █   █     ▒█    █   
   █    █▓ ▓█   █     █    █ █▓ ▓█  █░ ▒█    █░  
   █     ███    █     █    █  ███   ▒███▒    ▒██ 
"
echo -e "€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€\n"
}

panel(){
    echo -e "Parámetros disponibles:\n - install\n - start\n - stop\n - check\n - change\n"
}

installhs(){
    grep "^HiddenServicePort 80 127.0.0.1:80$" /etc/tor/torrc > /dev/null
        if [ $? -ne 0 ]; then
            echo "Parece que no tienes ningun hidden service configurado en /etc/tor/torrc"
            echo "Te lo configuro"
            echo "HiddenServiceDir /var/lib/tor/hidden_service/" >> /etc/tor/torrc
            echo "HiddenServicePort 80 127.0.0.1:80" >> /etc/tor/torrc
        else
            echo "Parece que tienes un hidden service configurado en /etc/tor/torrc"
        fi
}

starths(){
    systemctl restart tor
    status=`systemctl status tor | grep active`
    echo "Levantado."$status
    echo "Dirección onion generada:"
	sleep 1
    cat /var/lib/tor/hidden_service/hostname
}

stophs(){
    echo "Parando hidden service..."
    systemctl stop tor
    status=`systemctl status tor | grep active`
    echo "Parado."
}

checkhs(){
    echo "La direccion del hidden service es:"
    cat /var/lib/tor/hidden_service/hostname
    echo -e "\nConfiguración de puertos en /etc/tor/torrc:"
    grep "HiddenServicePort" /etc/tor/torrc | tail -n 2
}

changehs(){
    echo "Cambiando direccion del hidden service..."
    systemctl stop tor
    rm -rf /var/lib/tor/hidden_service/*
    systemctl start tor
    echo "Tu nueva direccion es:"
	sleep 1
    cat /var/lib/tor/hidden_service/hostname
}

listenhs(){
    echo "Configurando el servicio oculto para apuntar al listener de Netcat en el puerto $port..."
    
    if grep -q "HiddenServicePort" /etc/tor/torrc; then
        # Sobrescribir las líneas de configuración
        echo "Sobrescribiendo la configuración en el archivo torrc..."
        sed -i "/HiddenServicePort/c\HiddenServicePort 80 127.0.0.1:$port" /etc/tor/torrc
        # Reiniciar el servicio Tor para aplicar los cambios
        systemctl restart tor
    else
        # Agregar las líneas de configuración si no existen
        echo "Configurando el archivo torrc..."
        echo "HiddenServiceDir /var/lib/tor/hidden_service/" >> /etc/tor/torrc
        echo "HiddenServicePort 80 127.0.0.1:$port" >> /etc/tor/torrc
        # Reiniciar el servicio Tor para aplicar los cambios
        systemctl restart tor
    fi
}

start(){
    [ "$(id -u)" != "0" ] && echo "Este script debe ser ejecutado como root" && exit 1
    command -v tor >/dev/null 2>&1 || { echo >&2 "Tor no está instalado en el sistema."; exit 1; }
}

cmd=$1
port=4444
if [ -z "$1" ]; then
    banner
    panel
    exit 1
fi

opciones(){
    if [ $cmd = "start" ]; then
        starths
    elif [ $cmd = "stop" ]; then
        stophs
    elif [ $cmd = "change" ]; then
        changehs
    elif [ $cmd = "check" ]; then
        checkhs
    elif [ $cmd = "install" ]; then
        installhs
    elif [ $cmd = "listen" ]; then
        listenhs
    elif [ $cmd = "" ]; then
        echo "Parámetro inválido."
    else
        echo "Parámetro inválido." 
    fi
}
banner
start
opciones
