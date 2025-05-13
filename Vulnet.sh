#!/bin/bash
# shellcheck disable=SC2162

# Este script está diseñado para escanear toda la red usando arp-scan y nmap y permite elegir un host para escanear sus vulnerabilidades.
# Está diseñado para ejecutarse en una terminal y requiere privilegios de root.

# Trap para poder controlar el uso de Ctrl+C. Tal y como recomendó Jorge.
trap ctrl_c INT
function ctrl_c() {
    echo ""
    echo "Saliendo del script..."
    exit 0
}

# Función para mostrar el menú
function mostrar_menu() {
    echo "¡Bienvenido al script!"
    echo "--------------------------------"
    # Condición para verificar si el usuario es root
    if [[ $USER != root ]]; then
        echo "Este script debe ejecutarse como root. Por favor, inicie el script con privilegios."
        exit 1
    fi
    echo "Este script te permite escanear toda tu red y elegir un host para escanear sus vulnerabilidades."
    echo "--------------------------------"
    read -p "¿Desea escanear la red? (s/n): " siono
}

# Función para escanear la red
function escanear_red() {
        echo "Escaneando la red..."
        # Uso de arp-scan para escanear la red, el grep filtra las direcciones IP
        arp-scan --localnet --quiet | awk '{print $1}' | grep -Eo "([0-9]{1,3}[\\.]){3}[0-9]{1,3}" | sort -n > subred.txt
        echo "Escaneo completo y guardado en subred.txt. Hosts encontrados:"
        echo "--------------------------------"
        cat subred.txt
        echo "--------------------------------"
}

# Función para escanear un host de la lista
function escanear_host() {
    read -p "Por favor, introduce la dirección IP del equipo que deseas escanear a raíz de la direcciones IP encontradas con el escaneo anterior: " host
    if grep "$host" subred.txt > /dev/null; then
        echo "Escaneando el host $host..."
        nmap -A --script=vuln "$host" > "$host"_vuln.txt
        echo Escaneo completo y guardado en "$host"_vuln.txt. Resultados:
        echo "--------------------------------"
        cat "$host"_vuln.txt
        echo "--------------------------------"
    else
        echo "---------------------------------"
        echo "El host $host no se encuentra en la lista de hosts escaneados, por favor, escriba uno que esté en dicha lista."
        echo "---------------------------------"
        escanear_host
    fi
}

# Bucle que inicia el script
while true; do
    mostrar_menu
    if [ "$siono" != "s" ] && [ "$siono" != "S" ]; then
    echo "Tenga en cuenta que el script puede que no funcione si no escaneó la red previamente"
        escanear_host
    else
        escanear_red
        escanear_host
    fi
    read -p "¿Quieres escanear otro host? (s/n): " respuesta
    if [ "$respuesta" != "s" ] && [ "$respuesta" != "S" ]; then
        echo "Saliendo del script..."
        exit 0
        else
        escanear_host
    fi
done