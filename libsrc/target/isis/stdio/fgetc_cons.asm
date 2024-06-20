    SECTION code_clib
    PUBLIC  fgetc_cons

DEFC    ISIS = 0040H

fgetc_cons:
CINAGN:
	LD	C,3
	LD	DE,RBLK
	CALL	ISIS
	LD	A,(ACTUAL)
	OR	A
	JP	Z,CINAGN	; No character read - repeat
	LD      A,(RBUF)
	CP	0AH
	JP	Z,CINAGN	; LF YOU ARE NOT WELCOME HERE. GET OUT.
	MOV	L, A
	XOR	A
	MOV	H, A
	RET
RBLK:
RAFT:	DW      1               ; 1 is stdin
	DW	RBUF
RCNT:	DW	1
	DW	ACTUAL
	DW	RSTAT
ACTUAL: DS	2
RSTAT:	DS	2
RBUF:   DS	2
