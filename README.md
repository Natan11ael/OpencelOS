# OpencelOS

Um sistema operacional open source.

## Índice

- [Descrição](#descrição)
- [Funcionalidades](#funcionalidades)
- [Instalação](#instalação-e-execução)
- [Como Contribuir](#como-contribuir)
- [Licença](#licença)

## Descrição

OpencelOS é um projeto de sistema operacional de código aberto, focado em aprendizado, experimentação e inovação. 

## Funcionalidades

- Interface de linha de comando

## Instalação e Execução
comandos para uso do projeto em maquinas windows / linux.

```bash
# 
git clone https://github.com/seu-usuario/OpencelOS.git
cd OpencelOS

# 
make all    # compila src
make run    # executa compilação
make clean  # limpa compilação
```

## Estrutura de pastas
```bash
/opencel-os
├── Makefile              # Automação do build
├── linker.ld             # Script de linkagem
├── include/              # Arquivos de cabeçalho (.h)
│   ├── drivers/
│   │   ├── vga.h         # Definições de hardware
│   │   └── terminal.h    # Interface do terminal
│   └── lib/
│       └── string.h      # Funções utilitárias
├── src/                  # Código fonte (.c, .asm)
│   ├── boot.asm          # Bootloader (se houver)
│   ├── kernel.c          # Entrada principal
│   ├── drivers/
│   │   └── terminal.c    # Lógica do terminal
│   └── lib/
│       └── string.c      # Implementação de strings
└── .build/                # Objetos (.o) e binário final (gerado pelo Make)
```

## Como Contribuir

1. Faça um fork do projeto
2. Crie uma branch (`git checkout -b feature/NovaFuncionalidade`)
3. Commit suas alterações (`git commit -am 'Adiciona nova funcionalidade'`)
4. Push para a branch (`git push origin feature/NovaFuncionalidade`)
5. Abra um Pull Request

## Licença

Este projeto está licenciado sob a [MIT License](LICENSE).