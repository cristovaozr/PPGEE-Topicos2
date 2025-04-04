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
#include <stdint.h>

// Includes trazidos de testaRAM.c
#include "trataHEX.h"
#include "ram.h"
#include "peripheral.h"

#define PORT_1_MEM_BASE 0x40000
#define PORT_1_ADDR_SPAN 2
#define PORT_1_MEM_SPAN PORT_1_ADDR_SPAN*32

// Endereços de RAM para a Dual Port RAM
#define CONTROL_REGISTER_ADDR   0x00
#define DATA_IN_REGISTER_ADDR   0x01
#define DATA_OUT_REGISTER_ADDR  0x02
#define STATUS_REGISTER_ADDR    0x03

//UDP
#define N_BUF    20

#define MAGIC_NUMBER 0xdeadbeef
#define LISTENING_PORT 9090

static uint32_t calculate_mult4(peripheral *dpram, uint32_t A, uint32_t B)
{
    A &= 0x0f;
    B &= 0x0f;

    // Reinicia o periférico de produto
    peripheral_write8(*dpra, CONTROL_REGISTER_ADDR, 0x00);
    
    // Escreve os registradores A e B
    peripheral_write8(*dpram, DATA_IN_REGISTER_ADDR, (B<<4) | A);
    
    // Inicia o cálculo do produto de A e B
    peripheral_write8(*dpram, CONTROL_REGISTER_ADDR, 0x01);

    // Aguarda o final do cálculo
    while (1) {
        uint8_t completed = peripheral_read8(*dpram, STATUS_REGISTER_ADDR);
        if (completed) break;
    }

    // Lê o resultado
    uint32_t Y = peripheral_read8(*dpram, DATA_OUT_REGISTER_ADDR);
    return Y;
}

int main(int argc, char **argv)
{
    int ret = 0;
    int sock_udp, server_sock;
    socklen_t from_len;
    struct sockaddr_in server;
    struct sockaddr_in from;

    struct data {
        uint32_t magic_number;
        uint32_t A;
        uint32_t B;
    } data_in;

    struct {
        uint32_t magic_number;
        uint32_t Y;
    } data_out;

    printf("Configurando acesso à Dual Port RAM...\n");
    peripheral dualPortRam = peripheral_create(PORT_1_MEM_BASE, PORT_1_MEM_SPAN);
    usleep(1000*1000);

    sock_udp = socket(AF_INET, SOCK_DGRAM, 0);
    if (sock_udp < 0) {
        perror("socket()");
        ret = sock_udp;
        goto exit;
    }

    memset(&server, 0x00, sizeof(server));
    server.sin_addr.s_addr = INADDR_ANY;
    server.sin_family = AF_INET;
    server.sin_port = htons(LISTENING_PORT);
    if (bind(sock_udp, (struct sockaddr *)&server, sizeof(server)) < 0) {
        perror("bind()");
        ret = -1;
        goto exit;
    }

    printf("Ouvindo na porta %u...\n", LISTENING_PORT);
    while (1) {
        printf("Esperando pacote chegar...\n");
        memset(&data_in, 0x00, sizeof(data_in));
        ssize_t len = 0;
        do {
            len += recvfrom(sock_udp, &data_in, sizeof(data_in) - len, 0, (struct sockaddr *)&from, &from_len);
        } while (len < sizeof(data_in));

        if (data_in.magic_number != MAGIC_NUMBER) {
            printf("Pacote recebido não foi entendido\n");
            continue;
        }

        printf("Pacote recebido!\nMAGIC_NUMBER==[%.8x]\nA==[%u]\nB==[%u]\n", data_in.magic_number, data_in.A, data_in.B);

        data_out.magic_number = MAGIC_NUMBER;
        data_out.Y = calculate_mult4(data_in.A, data_in.B);

        len = 0;
        do {
            len += sendto(sock_udp, &data_out, sizeof(data_out), 0, (struct sockaddr *)&from, sizeof(from));
        } while (len < sizeof(data_out));
    }

    exit:
    return ret;
}
