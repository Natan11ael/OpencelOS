# Ferramentas
AS      := nasm
CC      := gcc
LD      := ld
OBJCOPY := objcopy
QEMU    := qemu-system-i386

# Flags
ASFLAGS := -f win32
CFLAGS  := -m32 -ffreestanding -O0 -g -fno-pie -fno-stack-protector -Iinclude -MMD -MP
LDFLAGS := -m i386pe -T linker.ld

# Diretórios
SRCDIR   := src
BUILDDIR := build

# --- BUSCA DE ARQUIVOS ---
# Listamos manualmente ou via wildcard as pastas que você criou
SOURCES := $(wildcard $(SRCDIR)/*.c) \
           $(wildcard $(SRCDIR)/drivers/*.c) \
           $(wildcard $(SRCDIR)/lib/*.c)

# Mapeia src/arquivo.c para build/arquivo.o
# Isso remove o prefixo "src/" e adiciona "build/"
OBJS := $(patsubst $(SRCDIR)/%.c, $(BUILDDIR)/%.o, $(SOURCES))

# Arquivos Fixos
BOOT_BIN   := $(BUILDDIR)/boot.bin
ENTRY_OBJ  := $(BUILDDIR)/kernel_entry.o
KERNEL_BIN := $(BUILDDIR)/kernel.bin
IMAGE      := $(BUILDDIR)/os-image.bin

.PHONY: all run clean

all: $(IMAGE)

# 1. Gera a imagem final
$(IMAGE): $(BOOT_BIN) $(KERNEL_BIN)
	@echo [IMAGE] Criando $@...
	@copy /b $(subst /,\,$(BOOT_BIN)) + $(subst /,\,$(KERNEL_BIN)) $(subst /,\,$(IMAGE)) > nul

# 2. Linkagem do Kernel
$(KERNEL_BIN): $(ENTRY_OBJ) $(OBJS)
	@echo [LD] Linkando Kernel...
	@$(LD) $(LDFLAGS) -o $(BUILDDIR)/kernel.tmp $(ENTRY_OBJ) $(OBJS)
	@$(OBJCOPY) -O binary $(BUILDDIR)/kernel.tmp $@

# 3. Compilação do Bootloader
$(BOOT_BIN): $(SRCDIR)/boot.asm
	@if not exist $(subst /,\,$(BUILDDIR)) mkdir $(subst /,\,$(BUILDDIR))
	@echo [AS] $<
	@$(AS) -f bin $< -o $@

# 4. Compilação do Entry Point (kernel_entry.asm)
$(ENTRY_OBJ): $(SRCDIR)/kernel_entry.asm
	@if not exist $(subst /,\,$(BUILDDIR)) mkdir $(subst /,\,$(BUILDDIR))
	@echo [AS] $<
	@$(AS) $(ASFLAGS) $< -o $@

# 5. Regra Genérica para arquivos C
$(BUILDDIR)/%.o: $(SRCDIR)/%.c
	@if not exist $(subst /,\,$(@D)) mkdir $(subst /,\,$(@D))
	@echo [CC] $<
	@$(CC) $(CFLAGS) -c $< -o $@

# Inclui os arquivos de dependência (.d) se eles existirem
# O sinal de '-' evita erro caso os arquivos ainda não tenham sido criados
-include $(OBJS:.o=.d)

run: all
	$(QEMU) -drive file=$(IMAGE),format=raw,index=0,media=disk

clean:
	@if exist $(BUILDDIR) rd /s /q $(BUILDDIR)
	@echo [CLEAN] Pasta build removida.