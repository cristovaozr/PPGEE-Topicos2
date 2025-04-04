#!/bin/bash
PASTA_LOCAL="./testaRAM"
IP_DESTINO="root@192.168.0.100"
PASTA_DESTINO="testaRAM"
echo "Subindo Arquivos do Projeto - $PASTA_LOCAL:"
scp $PASTA_LOCAL/* $IP_DESTINO:/home/root/tc2_fpga_pds/$PASTA_DESTINO
echo "Subindo Bibliotecas comuns a todos os projetos:"
scp ./INC/* $IP_DESTINO:/home/root/INC


