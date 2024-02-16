import socket
from concurrent.futures import ThreadPoolExecutor
from tqdm import tqdm

red_ascii_art = '''
\033[91m █████╗ ███╗   ██╗ █████╗ ██████╗ ███████╗    ███████╗ ██████╗ █████╗ ███╗   ██╗███╗   ██╗███████╗██████╗ 
██╔══██╗████╗  ██║██╔══██╗██╔══██╗██╔════╝    ██╔════╝██╔════╝██╔══██╗████╗  ██║████╗  ██║██╔════╝██╔══██╗
███████║██╔██╗ ██║███████║██████╔╝███████╗    ███████╗██║     ███████║██╔██╗ ██║██╔██╗ ██║█████╗  ██████╔╝
██╔══██║██║╚██╗██║██╔══██║██╔══██╗╚════██║    ╚════██║██║     ██╔══██║██║╚██╗██║██║╚██╗██║██╔══╝  ██╔══██╗
██║  ██║██║ ╚████║██║  ██║██║  ██║███████║    ███████║╚██████╗██║  ██║██║ ╚████║██║ ╚████║███████╗██║  ██║
╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝    ╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝
\033[0m
'''
print(red_ascii_art)

def port_scan(port):
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.settimeout(3)  # Set a timeout of 3 seconds
    try:
        result = sock.connect_ex((target, port))
        if result == 0:
            print(f"Port {port} is open")
    finally:
        sock.close()

target = input("Enter the IP address: ")
a = input("Do you want to scan all ports? Y/n: ")

if a.lower() in ['yes', 'y', 'ye'] or a == '':
    start_port = 0
    end_port = 65535
    print(f"It will be scanned from {start_port} to {end_port}.")
elif a.lower() in ['no', 'n']:
    start_port = int(input("What will be the first port? "))
    end_port = int(input("What will be the last port? "))
    print(f"It will be scanned from {start_port} to {end_port}.")

b = int(input("Write the speed of your test (1-5): "))
if b == 1:
    max_workers = 1
elif b == 2:
    max_workers = 10
elif b == 3:
    max_workers = 50
elif b == 4:
    max_workers = 100
else:
    max_workers = 500

with ThreadPoolExecutor(max_workers) as executor:
    # Use tqdm to create a progress bar for the port scanning
    for _ in tqdm(executor.map(port_scan, range(start_port, end_port + 1)), total=end_port - start_port + 1, desc="Scanning"):
        pass
