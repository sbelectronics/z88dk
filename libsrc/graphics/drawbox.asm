	xlib	drawbox
	lib	plotpixel

;
;	$Id: drawbox.asm,v 1.3 2002-03-28 09:41:14 stefano Exp $
;

; ***********************************************************************
;
; Clear specified graphics area in map.
; Generic version
;
; Stefano Bodrato - March 2002
;
;
; IN:	HL	= (x,y)
;	BC	= (width,heigth)
;

.drawbox

		push	bc
		push	hl

; -- Vertical lines --
		push	hl
		ld	a,h
		add	a,b
		ret	c	; overflow ?
		ld	h,a
		pop	de
.rowloop
		push	bc
		
		push	hl
		push	de
		call	plotpixel
		pop	de
		pop	hl
		inc	l
		ex	de,hl

		push	hl
		push	de
		call	plotpixel
		pop	de
		pop	hl
		inc	l
		ex	de,hl

		pop	bc
		dec	c
		jr	nz,rowloop

		pop	hl
		pop	bc

; -- Horizontal lines --
		push	hl
		ld	a,l
		add	a,c
		ret	c	; overflow ?
		ld	l,a
		pop	de

.vrowloop
		push	bc
		
		push	hl
		push	de
		call	plotpixel
		pop	de
		pop	hl
		inc	h
		ex	de,hl
		
		push	hl
		push	de
		call	plotpixel
		pop	de
		pop	hl
		inc	h
		ex	de,hl
		
		pop	bc
		
		djnz	vrowloop

		ret
