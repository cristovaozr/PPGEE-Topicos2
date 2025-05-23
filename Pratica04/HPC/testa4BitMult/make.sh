#!/bin/bash

MAINFILE="$1"
EXECNAME="$2"

if [ -z "$MAINFILE" -o -z "$EXECNAME" ]; then
    echo "Por favor especifique o arquivo a compilar e a saida!"
    exit 1
fi

if ls *.o >/dev/null 2>&1; then
    rm ./*.o
fi

gcc -c -I../INC/ ../INC/*.c  ./$MAINFILE
gcc -I../INC/ ./*.o -o ./$EXECNAME
