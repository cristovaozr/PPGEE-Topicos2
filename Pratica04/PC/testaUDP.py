#OBJETIVO: Abrir um socket UDP escrever uma mensagem e esperar resposta
#PROJETO:  FINITE FIELD GF256 COSINE TRANSFORMS
#DATA DE CRIACAO: 28/08/2024 
import socket
import numpy


msgFromClient       = "Testando comunicacao"
bytesToSend         = str.encode(msgFromClient)
serverAddressPort   = ("192.168.1.19", 9090) 
bufferSize          = len(bytesToSend)

 

# Create a UDP socket at client side
UDPClientSocket = socket.socket(family=socket.AF_INET, type=socket.SOCK_DGRAM)

print("ATENÇÃO! ENVIANDO PACOTE PARA A PORTA -",serverAddressPort)

print("Mensagem  a ser enviada:", msgFromClient)

print("Enviando a mensagem pelo socket criado")
UDPClientSocket.sendto(bytesToSend, serverAddressPort)


print("Esperando receber algo:")
msgFromServer = UDPClientSocket.recvfrom(bufferSize)

 
print("Mensagem recebida:")
msg = "Message from Server {}".format(msgFromServer[0])

print(msg)