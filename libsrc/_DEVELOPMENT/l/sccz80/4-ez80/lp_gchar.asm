

;
; Entry: EHL=far pointer
; Exit: a=byte

lp_gchar:
    defb    $5b    ;lil
    push    hl
    defb    $5b    ;lil
    ld      hl,2
    defb    0
    defb    $5b
    add     hl,sp
    defb    $5b
    ld      (hl),e
    defb    $5b
    pop     hl
    defb    $5b
    ld      a,(hl)
    ret
