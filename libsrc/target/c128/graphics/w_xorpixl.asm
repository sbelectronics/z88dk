    INCLUDE "graphics/grafix.inc"

    SECTION code_graphics
    PUBLIC  w_xorpixel

    EXTERN  l_cmp

    EXTERN  __c128_vaddr
    EXTERN  w_pixeladdress

    EXTERN  __gfx_coords

;
;       $Id: w_xorpixl.asm $
;

; ******************************************************************
;
; XOR pixel at (x,y) coordinate.
;
; Wide resolution (WORD based parameters) version by Stefano Bodrato
;
; Design & programming by Gunther Strube, Copyright (C) InterLogic 1995
;
; The (0,0) origin is placed at the top left corner.
;
; in:  hl,de    = (x,y) coordinate of pixel
;
; registers changed after return:
;  ......../ixiy same
;  afbcdehl/.... different
;
w_xorpixel:

    push    hl
    ld      hl, maxy
    call    l_cmp
    pop     hl
    ret     nc                          ; Return if Y overflows

    push    de
    ld      de, maxx
    call    l_cmp
    pop     de
    ret     c                           ; Return if X overflows

    ld      (__gfx_coords), hl          ; store X
    ld      (__gfx_coords+2), de        ; store Y: COORDS must be 2 bytes wider

    call    w_pixeladdress

    ld      b, a
    ld      a, 1
    jr      z, xor_pixel                ; pixel is at bit 0...
plot_position:
    rlca
    djnz    plot_position
xor_pixel:

    call    __c128_vaddr
    in      e, (c)

    xor     e                           ; set pixel in current byte

    call    __c128_vaddr
    out     (c), a

    ret
