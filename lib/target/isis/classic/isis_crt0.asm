    MODULE  isis_crt0


    defc    crt0 = 1
    INCLUDE "zcc_opt.def"

DEFC    ISIS = 0040H

    EXTERN    _main             ;main() is always external to crt0

    PUBLIC    __Exit
    PUBLIC    l_dcal            ;jp(hl)


IF      !DEFINED_CRT_ORG_CODE
    defc    CRT_ORG_CODE  = $3680
ENDIF

    defc    TAR__clib_exit_stack_size = 8
    defc    TAR__register_sp = $F000            ; put stack at 0xF000
    defc    TAR__crt_stack_size = 512           ; reserve 512 bytes for stack
    defc    __CPU_CLOCK = 4000000
    INCLUDE "crt/classic/crt_rules.inc"

    org     CRT_ORG_CODE

start:
    ; WARNING -- the following statement will PUSH HL onto
    ;            the stack, and the current SP might be right
    ;            in the middle of the program.
    ;            ... ask me how I know ...

    ;ld      (__restore_sp_onexit+1),sp  ;Save entry stack (DO NOT UNCOMMENT)

    INCLUDE "crt/classic/crt_init_sp.inc"

    call    crt0_init

    INCLUDE "crt/classic/crt_init_atexit.inc"

    INCLUDE "crt/classic/crt_init_heap.inc"

    JP       argproc
apret:
    push    hl
    push    bc
    call    _main               ;Call user code
    pop     bc
    pop     bc

__Exit:
    ; something down there in crt0_exit fails.
    ; ... so just exit ISIS here. Bring down the hammer.
    LD      C,09H           ; EXIT ISIS
    JP      ISIS

    push	hl
    call    crt0_exit
    pop     bc 

    ; See WARNING higher on up.
;__restore_sp_onexit:
;    ld      sp,0

l_dcal:
    jp      (hl)

;-------------- argument processor ----------------

argproc:
	LD	C,3
	LD	DE,RBLK
	CALL	ISIS
    LD  A, (ACTUAL)             ; Get actual bytes in A
    ORA A
    JP Z, argv_done             ; There should be at least a CR, but just in case...
    MOV C,A                     ; C = byte count    
    LD  HL, RBUF
    ADD A,L                     ; HL = HL + A
    LD L,A
    JP NC, NOWRAP
    INC H
NOWRAP:
    LD (HL),0                   ; zero terminate one byte past end of cmdline, just in case...
    DEC HL                      ; move to last char in cmdline
    LD A,(HL)                   ; args probably ends with CRLF
    CMP 0AH                     ; if so, remove them
    JP NZ, NOTLF
    LD (HL),0
    DEC C
    DEC HL
NOTLF:
    LD A,(HL)
    CMP 0DH
    JP NZ, NOTCR
    LD (HL),0
    DEC C
    DEC HL
NOTCR:
    MOV A,C
    ORA A
    JP Z, argv_done
    DEC C                       ; don't count the leading space
    LD B,0
    INCLUDE     "crt/classic/crt_command_line.inc"
	JP apret                    ; return with stuff on the stack

RBLK:
RAFT:	DW      1               ; 1 is stdin
	    DW	RBUF
RCNT:	DW	70H
	    DW	ACTUAL
	    DW	RSTAT
ACTUAL: DW  0                   ; Default to 0
RSTAT:	DS	2
JUNK:   DB  0                   ; placeholder to ensure null before start of buf
RBUF:   DS	81H

    INCLUDE "crt/classic/crt_runtime_selection.inc"   

    INCLUDE	"crt/classic/crt_section.inc"

