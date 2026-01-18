// src/kernel.c
void kernel_main() {
    volatile char* video_memory = (volatile char*) 0xb8000;
    
    // H - Azul (0x01)
    video_memory[0] = 'H';
    video_memory[1] = 0x01;

    // e - Verde (0x02)
    video_memory[2] = 'e';
    video_memory[3] = 0x02;

    // l - Ciano (0x03)
    video_memory[4] = 'l';
    video_memory[5] = 0x03;

    // l - Vermelho (0x04)
    video_memory[6] = 'l';
    video_memory[7] = 0x04;

    // o - Magenta (0x05)
    video_memory[8] = 'o';
    video_memory[9] = 0x05;

    // Espaço - (0x07 cinza padrão)
    video_memory[10] = ' ';
    video_memory[11] = 0x07;

    // W - Marrom/Laranja (0x06)
    video_memory[12] = 'W';
    video_memory[13] = 0x06;

    // o - Cinza Claro (0x07)
    video_memory[14] = 'o';
    video_memory[15] = 0x07;

    // r - Cinza Escuro (0x08)
    video_memory[16] = 'r';
    video_memory[17] = 0x08;

    // l - Azul Claro (0x09)
    video_memory[18] = 'l';
    video_memory[19] = 0x09;

    // d - Verde Claro (0x0A)
    video_memory[20] = 'd';
    video_memory[21] = 0x0A;

    // ! - Vermelho Claro (0x0C)
    video_memory[22] = '!';
    video_memory[23] = 0x0C;

    while(1);
}