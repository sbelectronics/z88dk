    SECTION code_clib
    PUBLIC  fputc_cons_native

DEFC    ISIS = 0040H

	; Note: we

fputc_cons_native:
	ld      hl, 02H
    	add     hl, sp
    	ld      a, (hl)                     ; Now A contains the char to be printed
	AND	07FH		; strip the high bit

	CMP	A, 0AH		; Is it a newline?
	JP	NZ, NOTLF
	LD	A, 0DH		; output a CR
	LD	(WBUF), A	
	LD	C,4
	LD	DE,WBLK
	CALL	ISIS
	LD	A, 0AH		; restore the LF
NOTLF:
	LD	(WBUF), A	; output the character
	LD	C,4
	LD	DE,WBLK
	CALL	ISIS
	RET
WBLK:
WAFT:	DW      0               ; 0 is stdout
	DW	WBUF
WCNT:	DW	1
	DW	WSTAT
WSTAT:  DS	2
WBUF:	DS	2
