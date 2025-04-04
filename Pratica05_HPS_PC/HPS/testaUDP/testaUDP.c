/*
* FUNCAO : Testar Comunicacao UDP
* PROJETO: TOPICOS EM COMUNICAO 02
* DATA DE CRIACAO: 26/03/2025
*/


//Do codigo basico
#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>
#include "hwlib.h"
#include "socal.h"
#include "hps.h"
#include "alt_gpio.h"
#include "hps_0.h"

//do codigo de Breno
#include <string.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/ipc.h> 
#include <sys/shm.h> 
#include <time.h> 
#include <math.h> 
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>

#include <unistd.h>


//UDP
#define N_BUF    20

int main() 
{
	//Codigo UDP:
	int sock, length, n, flags;
	socklen_t fromlen;
	struct sockaddr_in server;
	struct sockaddr_in from;
	char buf[N_BUF];
	

	sock=socket(AF_INET, SOCK_DGRAM, 0);
	if (sock < 0) printf("Opening socket");

	length = sizeof(server);
	bzero(&server,length);
	server.sin_family=AF_INET;
	server.sin_addr.s_addr=INADDR_ANY;
	server.sin_port=htons(9090);
	if (bind(sock,(struct sockaddr *)&server,length)<0) 
	    printf("binding");
	fromlen = sizeof(struct sockaddr_in);
	//


	printf("*---------------------------------------------------------------------\n");
	printf("* FUNCTION       : UDP COMMUNICATION TEST\n");
	printf("* PROJECT        : TOPICOS EM COMUNICAO 02\n");
	printf("* DATE           : 2025.1 - 26/03/2025\n");
	printf("*---------------------------------------------------------------------\n");

	while(1)
	{
		printf("Aguardando pacote do PC...\n");
		bzero(buf,N_BUF);
	   	n = recvfrom(sock,buf,N_BUF,0,(struct sockaddr *)&from,&fromlen);
	   	if (n < 0) printf("recvfrom");
	   	else
	   	{
			printf("Esperando um tempo\n");
			usleep(1000); //Esperando um tempo para ver se o python espera a mensagem;
			printf("Devolvendo pacote recebido:\n");
			n = sendto(sock,buf,N_BUF,0,(struct sockaddr *)&from,fromlen);
			if (n  < 0) printf("sendto");						
		}
	}	
}
