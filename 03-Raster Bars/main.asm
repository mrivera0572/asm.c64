.pc = $801
:BasicUpstart(2064)

.pc = $810 "Program"
	sei
	lda #$7f
	ldx #1
	sta $dc0d
	sta $dd0d
	sta $d01a
	
	lda #$1b
	ldx #$c8
	ldy #$14
	sta $d011 // text mode, high bit of $d012 0
	stx $d016 // single color
	sty $d018 // screen at $0400, char at $2000
	
	lda #<int1
	ldx #>int1
	ldy #$20
	sta $0314
	stx $0315
	sty $d012
	
	lda $dc0d
	lda $dd0d
	asl $d019
	
	cli
	
loop:
	jmp loop
	
int1:
	jsr loadcolor
	sta $d020
	sta $d021
	lda #<int2
	ldx #>int2
	ldy #$30
	sta $0314
	stx $0315
	sty $d012
	asl $d019
	
	ldx #0

	
	pla
 	tay
 	pla
 	tax
 	pla
	rti

int2:
	jsr loadcolor
	sta $d020
	sta $d021
	lda #<int3
	ldx #>int3
	ldy #$40
	sta $0314
	stx $0315
	sty $d012
	asl $d019
	
	pla
 	tay
 	pla
 	tax
 	pla
	rti

int3:
	jsr loadcolor
	sta $d020
	sta $d021
	lda #<int4
	ldx #>int4
	ldy #$50
	sta $0314
	stx $0315
	sty $d012
	asl $d019

 	pla
 	tay
 	pla
 	tax
 	pla
	rti

int4:
	lda #6
	sta $d020
	sta $d021
	lda #<int1
	ldx #>int1
	ldy #$20
	sta $0314
	stx $0315
	sty $d012
	asl $d019
	
	pla
 	tay
 	pla
 	tax
 	pla
	rti

loadcolor:
	ldx cid
	lda color, x
	cmp #0
	beq resetcolor
	inc cid
	rts

resetcolor:
	lda #$0
	sta cid
	lda color
	rts
	
wait:
	ldx #0
	dex
	bne wait
	rts

cid: .byte 0	
color: 
.byte $01, $01, $01, $01, $01, $01, $02, $02, $03, $04, $04, $05, $06, $07, $08, $09
.byte $0a, $0c, $0d, $0e, $10, $11, $13, $15, $16, $18, $1a, $1c, $1e, $20, $22, $24
.byte $26, $29, $2b, $2d, $30, $32, $35, $37, $3a, $3d, $3f, $42, $45, $48, $4b, $4d
.byte $50, $53, $56, $59, $5c, $5f, $62, $65, $69, $6c, $6f, $72, $75, $78, $7b, $7e
.byte $82, $85, $88, $8b, $8e, $91, $94, $97, $9b, $9e, $a1, $a4, $a7, $aa, $ad, $b0
.byte $b2, $b5, $b8, $bb, $be, $c0, $c3, $c6, $c8, $cb, $cd, $d0, $d2, $d5, $d7, $d9
.byte $db, $de, $e0, $e2, $e4, $e6, $e7, $e9, $eb, $ed, $ee, $f0, $f1, $f2, $f4, $f5
.byte $f6, $f7, $f8, $f9, $fa, $fb, $fc, $fc, $fd, $fd, $fe, $fe, $fe, $fe, $fe, $ff
.byte $fe, $fe, $fe, $fe, $fe, $fd, $fd, $fc, $fb, $fb, $fa, $f9, $f8, $f7, $f6, $f5
.byte $f3, $f2, $f1, $ef, $ee, $ec, $ea, $e9, $e7, $e5, $e3, $e1, $df, $dd, $db, $d9
.byte $d6, $d4, $d2, $cf, $cd, $ca, $c8, $c5, $c2, $c0, $bd, $ba, $b7, $b4, $b2, $af
.byte $ac, $a9, $a6, $a3, $a0, $9d, $9a, $96, $93, $90, $8d, $8a, $87, $84, $81, $7d
.byte $7a, $77, $74, $71, $6e, $6b, $68, $64, $61, $5e, $5b, $58, $55, $52, $4f, $4d
.byte $4a, $47, $44, $41, $3f, $3c, $39, $37, $34, $32, $2f, $2d, $2a, $28, $26, $24
.byte $21, $1f, $1d, $1b, $19, $18, $16, $14, $12, $11, $0f, $0e, $0d, $0b, $0a, $09
.byte $08, $07, $06, $05, $04, $03, $03, $02, $02, $01, $01, $01, $01, $01, $00