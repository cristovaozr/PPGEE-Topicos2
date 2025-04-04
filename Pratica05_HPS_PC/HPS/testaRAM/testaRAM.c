/*
* FUNCAO : Testa a RAM do periferico 
* PROJETO: Finite Field 256 Cosine Transforms
* DATA DE CRIACAO: 27/08/2024
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

//Feitas por mim
#include "trataHEX.h"
#include "ram.h"
#include "peripheral.h"

#define PORT_1_MEM_BASE 0x40000
#define PORT_1_ADDR_SPAN 2
#define PORT_1_MEM_SPAN PORT_1_ADDR_SPAN*32


//UDP
#define N 		64
#define N_PACKET 8
#define N_BUF 8

int main() 
{

	uint32_t i;        //para iteracoes
	uint32_t entrada;        //para iteracoes
	uint32_t mem_read;
	uint32_t mem_read_lsw;
	uint32_t mem_read_msw;
	uint32_t mem_write;
	uint16_t mem_read16;
	uint8_t  mem_read8;
	peripheral dualPortRam;




	printf("*---------------------------------------------------------------------\n");
	printf("* FUNCTION       : MULTIPILER BY CONSTANT RAM COMMUNICATION TEST\n");
	printf("* PROJECT        : FINITE FIELD GF256 COSINE TRANSFORMS\n");
	printf("* DATE           : 29/08/2024\n");
	printf("*---------------------------------------------------------------------\n");


	printf("defining the access to the memory peripherals\n");
	dualPortRam = peripheral_create(PORT_1_MEM_BASE, PORT_1_MEM_SPAN);
	//port02 = peripheral_create(PORT_2_MEM_BASE, PORT_2_MEM_SPAN);

	usleep(1000*1000);
	printf("Accessing the peripheral RAM:\n");
	printf("Writing in the RAM? (0 -> no ; 2 -> erease ram memory):\n");	
	scanf("%i", &entrada);
	if(entrada)
	{
		for(i = 0; i < (PORT_1_ADDR_SPAN); i++)
		{
			usleep(100);
			printf("writing %X in the memory \n",i);
			if(entrada == 2) //Zerar a memoriass
			{
				mem_write = 0;
			}
			else
			{
				mem_write = (0x01010101)+i;
			}
			
			printf("Endereco: %X, Valor: %X\n", 4*i, mem_write);
			peripheral_write32(dualPortRam,i,mem_write);
		}
	}	
	usleep(1000*1000);
	printf("Reading the RAM:\n");
	for(i = 0; i < PORT_1_ADDR_SPAN; i++)
	{
		usleep(100);
		mem_read =  peripheral_read32(dualPortRam,i);
		printf("Endereco: %X, Valor: %X\n", 4*i, mem_read);
		
	}
}
