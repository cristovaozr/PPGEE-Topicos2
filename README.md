# PPGEE-Topicos2

Códigos da disciplina de Tópicos de Telecomunicações 2 - PPGEE 2025.1

## Configurando o Quartus corretamente no Archlinux

Descobri, a duras penas, que o Quartus depende da possibilidade de stack executável. Pra isso, no Archlinux é necessário instalar um programa chamado `execstack`, presente no AUR.

```bash
yay -S execstack
```

Depois é necessário habilitar isso para vários arquivos `.so`. Não sei exatamente quais são, então fiz para todos:

```bash
cd $HOME/intelFPGA_lite/20.1/quartus/linux64
find . -type f -name '*.so' | xargs execstack -s
```

Isso deve ser suficiente para ajustar tudo

