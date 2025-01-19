import paramiko, time, sys
#import logging
# Activer les logs de débogage
#logging.basicConfig(level=logging.DEBUG)
# Détails de connexion
hostname = "127.0.0.1"
port = 22222
username = "jill"
password = "upthehill"

paramiko.SFTPFile.MAX_REQUEST_SIZE = 0Xffffffff

# Créer un client SFTP
print("WAIT", end="")
try:
    r = int(sys.argv[1])
except:
    r = 1
for i in range(r):
    print(".", end="")
    time.sleep(1)
print("")

transport = paramiko.Transport((hostname, port))
transport.connect(username=username, password=password)

def create_some_text(total: int) -> str:
    t = "Coucou tyy"
    t = t * ((total // len(t)) + 1)
    return t[:total]

def to_sftp(f):
    def wrapped():
        sftp = paramiko.SFTPClient.from_transport(transport)
        r = f(sftp)
        print("Fichiers sur le serveur SFTP:", r)
        # Fermer la connexion
        sftp.close()
        transport.close()
        return r
    return wrapped

@to_sftp
def second(sftp: paramiko.SFTPClient) -> str:
    # Lister les fichiers dans le répertoire racine
    with sftp.open("./dog.txt", "w") as file:
        file.write(create_some_text(10))
    with sftp.open("./dog.txt", "r") as file:
        files = file.read(0xffffffff)
    return files

@to_sftp
def first(sftp: paramiko.SFTPClient) -> str:
    return sftp.normalize(f"./{create_some_text(254)}")
