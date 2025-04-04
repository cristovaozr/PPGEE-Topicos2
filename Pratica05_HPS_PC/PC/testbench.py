#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Abr 04 11:04:53 2025

@author: cristovao.rufino@ufpe.br
"""

import socket
import struct
from tqdm import tqdm

MAGIC_NUMBER = 0xdeadbeef

DATA_OUT_FORMAT = "@III"
DATA_IN_FORMAT = "@II"

if __name__ == "__main__":

    print("Executando testbench para todos os números!")
    
    server_address   = ("192.168.26.2", 9090) 
    udp_socket = socket.socket(family=socket.AF_INET, type=socket.SOCK_DGRAM)
    
    passed = True    
    for tup in tqdm([(i, j) for i in range(0,16) for j in range(0, 16)]):
        i, j = tup
        prod = i*j
        data = struct.pack(DATA_OUT_FORMAT, MAGIC_NUMBER, i, j)
        
        # Agora começa a quebradeira!
        udp_socket.sendto(data, server_address)
        data_from_server, _ = udp_socket.recvfrom(struct.calcsize(DATA_IN_FORMAT))
        magic_number, Y = struct.unpack(DATA_IN_FORMAT, data_from_server)
    
        if magic_number != MAGIC_NUMBER:
            print("Pacote recebido não entendido!")
            continue
        
        passed = passed and (prod == Y)
        if prod != Y:
            print("Teste falhou em A=={i} e B=={j}")
    
    
    print()
    if passed:
        print("Sucesso!")
    else:
        print("Algum teste falhou!")        
                                            
    udp_socket.close()
    
    