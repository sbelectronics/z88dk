;   @feilipu 2018

IF __Z180

SECTION code_clib
SECTION code_math

PUBLIC l0_small_z180_mulu_32_32x32

l0_small_z180_mulu_32_32x32:

    ; multiplication of two 32-bit numbers into a 32-bit product
    ;
    ; enter : dede' = 32-bit multiplier   = x
    ;         bcbc' = 32-bit multiplicand = y
    ;         hlhl' = 0
    ;
    ; exit  : dehl  = 32-bit product
    ;         carry reset
    ;
    ; uses  : af, bc, de, hl, bc', de', hl'

    ; save material for the highest order byte p3 = x3*y0 + x2*y1 + x1*y2 + x0*y3 ++
    push de                     ; x3 x2
    exx
    push bc                     ; y1 y0
    push de                     ; x1 x0
    exx
    push bc                     ; y3 y2

    ; save material for the higher order byte p2 = x2*y0 + x0*y2 + x1*y1 + carry
    ; start of 32_32x32

    ld h,e
    ld l,c
    push hl                     ; x2 y2

    exx                         ; now we're working in the low order bytes
    ld h,e
    ld l,c
    push hl                     ; x0 y0

    ; save material for the higher order byte p1 = x1*y1 + carry
    ; start of 32_16x16

    ld h,d
    ld l,b
    push hl                     ; x1 y1

    ld h,d                      ; x1
    ld l,c                      ; y0

    ld d,c                      ; y0 e = x0
    ld c,e                      ; x0 b = y1

    ; bc = x0 y1
    ; de = x0 y0
    ; hl = x1 y0
    ; stack = x1 y1

    mlt de                      ; x0 * y0
    mlt bc                      ; x0 * y1
    mlt hl                      ; x1 * y0

    add hl,bc                   ; sum cross products p2 p1
    sbc a,a                     ; capture carry p3
    and $01                     ; isolate carry p3
    ld b,a
    ld c,h                      ; LSB of MSW from cross products

    ld a,d
    add a,l
    ld d,a                      ; LSW in DE p1 p0

    pop hl
    mlt hl                      ; x1 * y1

    adc hl,bc                   ; HL = interim MSW p3 p2
                                ; 32_16x16 = HLDE

    push hl                     ; stack interim p3 p2
    ex de,hl                    ; DEHL = end of 32_16x16

    ; start doing the p2 byte, using the existing HL

    exx                         ; now we're working in the high order bytes
                                ; DE'HL' = end of 32_16x16
    pop hl                      ; stack interim p3 p2

    pop bc                      ; x0 y0
    pop de                      ; x2 y2
    ld a,b
    ld b,d
    ld d,a
    mlt bc                      ; x2 * y0
    mlt de                      ; x0 * y2
    add hl,bc
    add hl,de

    ; start doing the p3 byte, using the existing H

    pop bc                      ; y3 y2
    pop de                      ; x1 x0
    ld a,b
    ld b,d
    ld d,a
    mlt bc                      ; x1 * y2
    mlt de                      ; y3 * x0

    ld a,h                      ; work with existing p3 from H
    add a,c                     ; add low bytes of products
    add a,e

    pop bc                      ; y1 y0
    pop de                      ; x3 x2
    ld a,b
    ld b,d
    ld d,a
    mlt bc                      ; x3 * y0
    mlt de                      ; y1 * x2

    add a,c
    add a,e
    ld h,a                      ; put p3 back in H

    push hl

    exx                         ; now we're working in the low order bytes, again
    pop de
    xor a                       ; carry reset
    ret                         ; exit  : DEHL = 32-bit product

ENDIF

