# Configurações de ferramentas
AS = nasm
CC = gcc
LD = ld
OBJCOPY = objcopy
QEMU = qemu-system-i386

# Flags
ASFLAGS = -f win32
CFLAGS = -m32 -ffreestanding -fno-pie -fno-stack-protector -Iinclude
LDFLAGS = -m i386pe -T src/linker.ld

# Diretórios
SRCDIR = src
BUILDDIR = build

# Arquivos
# Pega todos os arquivos .c dentro de src/
SOURCES = $(wildcard $(SRCDIR)/*.c)
# Transforma a lista de .c em .o dentro da pasta build/
OBJS = $(patsubst $(SRCDIR)/%.c, $(BUILDDIR)/%.o, $(SOURCES))
KERNEL_ENTRY_OBJ = $(BUILDDIR)/kernel_entry.o

# Alvo principal (o que será gerado)
all: $(BUILDDIR)/os-image.bin

# 6. Cria a imagem final (Boot + Kernel)
$(BUILDDIR)/os-image.bin: $(BUILDDIR)/boot.bin $(BUILDDIR)/kernel.bin
	@echo [build] Criando Imagem Final...
	copy /b $(subst /,\,$(BUILDDIR)\boot.bin + $(BUILDDIR)\kernel.bin $(BUILDDIR)\os-image.bin)

# 5. Compila o Bootloader
$(BUILDDIR)/boot.bin: $(SRCDIR)/boot.asm
	@if not exist $(BUILDDIR) mkdir $(BUILDDIR)
	@echo [build] Compilando Bootloader...
	$(AS) -f bin $< -o $@

# 4. Extração Binária e 3. Linkagem
$(BUILDDIR)/kernel.bin: $(KERNEL_ENTRY_OBJ) $(OBJS)
	@echo [build] Linkando e Gerando Binario do Kernel...
	$(LD) $(LDFLAGS) -o $(BUILDDIR)/kernel.tmp $(KERNEL_ENTRY_OBJ) $(OBJS)
	$(OBJCOPY) -O binary $(BUILDDIR)/kernel.tmp $@

# 1. Compila o Entry Point (Assembly)
$(KERNEL_ENTRY_OBJ): $(SRCDIR)/kernel_entry.asm
	@if not exist $(BUILDDIR) mkdir $(BUILDDIR)
	@echo [build] Compilando Entry Point...
	$(AS) $(ASFLAGS) $< -o $@

# 2. Compila os arquivos C (Regra Genérica)
$(BUILDDIR)/%.o: $(SRCDIR)/%.c
	@if not exist $(BUILDDIR) mkdir $(BUILDDIR)
	@echo [build] Compilando $<...
	$(CC) $(CFLAGS) -c $< -o $@

# 7. Executa no QEMU
run: all
	$(QEMU) -drive file=$(BUILDDIR)/os-image.bin,format=raw,index=0,media=disk -k pt-br

# Limpeza
clean:
	@if exist $(BUILDDIR) rd /s /q $(BUILDDIR)
	@echo [clean] Pasta build removida.
