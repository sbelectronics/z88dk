; int tape_load_block(void *addr, size_t len, unsigned char type)
; CALLER linkage for function pointers

PUBLIC tape_load_block
PUBLIC _tape_load_block

EXTERN tape_load_block_callee
EXTERN asm_tape_laod_block

.tape_load_block
._tape_load_block

   pop hl
   pop bc
   ld a,c
   pop de
   pop ix
   push hl
   push de
   push bc
   push hl
   
   jp asm_tape_laod_block
