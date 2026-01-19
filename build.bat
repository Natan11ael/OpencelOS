@echo off
cls
if not exist "build" mkdir "build"

:: 1. Compila o Entry Point (Assembly)
:: Usamos -f win32 para criar um objeto compatível com o linker do Windows
echo [build] Compilando Kernel Entry...
nasm -f win32 src/kernel_entry.asm -o build/kernel_entry.o

:: 2. Compila o Kernel C
echo [build] Compilando Kernel C...
gcc -m32 -ffreestanding -fno-pie -fno-stack-protector -c src/*.c
move *.o build/

:: 3. Linkagem (A ORDEM IMPORTA!)
:: Note que kernel_entry.o vem ANTES de kernel.o
echo [build] Linkando Kernel...
ld -m i386pe -T src/linker.ld -o build/kernel.tmp build/kernel_entry.o build/*.o

:: 4. Extração Binária
echo [build] Gerando Binario do Kernel...
objcopy -O binary build/kernel.tmp build/kernel.bin

:: 5. Compila o Bootloader
echo [build] Compilando Bootloader ASM...
nasm -f bin src/boot.asm -o build/boot.bin

:: 6. Cria a Imagem Final
echo [build] Criando Imagem Final...
if not exist "build/kernel.bin" (
    echo [ERRO] kernel.bin nao foi gerado!
    pause
    exit /b
)
copy /b build\boot.bin + build\kernel.bin build\os-image.bin

:: 7. Executa
if not exist "build/os-image.bin" (
    echo [ERRO] Falha ao criar a imagem.
    pause
    exit /b
)
echo [build] Executando no QEMU...
qemu-system-x86_64 -drive file=build/os-image.bin,format=raw,index=0,media=disk -k pt-br