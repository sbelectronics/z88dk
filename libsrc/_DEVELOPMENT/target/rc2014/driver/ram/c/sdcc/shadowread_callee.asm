
; void *shadowread_callee(void * restrict s1, const void * restrict s2, size_t n)

SECTION smc_lib

PUBLIC _shadowread_callee

EXTERN asm_push_di
EXTERN asm_pop_ei_jp

EXTERN asm_shadowcopy

._shadowread_callee

   pop af
   pop de
   pop hl
   pop bc
   push af

   call asm_push_di

   ld a,$01     ; set up read from shadow ram

   call asm_shadowcopy
   jp asm_pop_ei_jp
