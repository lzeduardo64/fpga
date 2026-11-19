# Console FPGA
Implementação de um console minimo utilizando a placa Sipeed Tang Nano 20k.

O objetivo final desse projeto é fazer um dispositivo capaz de gerar graficos 3D simples com um pequeno firmware capaz de 
carregar um pequeno OS pelo microsd.

## Estrutura
- CPU RISC V (TODO)
- GPU com gráficos simples (TODO)
- Encoder HDMI


## Compilação
Para este projeto, utilizei o [OSS-CAD-SUITE](https://github.com/yosyshq/oss-cad-suite-build) para obter os programas.
Baixe a toolchain e ative o ambiente:
```
source oss-cad-suite/environment
```

Para compilar o projeto, basta rodar
```
make
```

Para fazer upload do projeto para uma placa na SRAM
```
make upload
```

Para gravar o projeto na memória flash da placa:
```
make flash
```

Ou então, para testar o projeto sem utilizar a placa:
```
make test
```
