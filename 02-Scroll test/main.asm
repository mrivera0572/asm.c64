.var brkFile = createFile("breakpoints.txt") 
.eval brkFile.writeln("ll \"main.vs\"")

.macro break() {
	.eval brkFile.writeln("break " + toHexString(*))
}

.pc = $801 "Basic loader"
:BasicUpstart(2064)

.pc = $0810 "Program" 

 	sei // Disable interrupts
 	lda #$7f
 	ldx #$01
 	sta $dc0d // Disable CIA 1 interrupts
 	sta $dd0d // Disable CIA 2 interrupts
 	stx $d01a // Enable raster interrupts
 	
 	lda #$1b
 	ldx #$c8
 	ldy #$14
 	sta $d011 // Clear high bit of $d012, set text mode
 	stx $d016 // Single color
 	sty $d018 // Screen at $0400, charset at $2000
 	
 	lda #<int
 	ldx #>int
 	ldy #$20
 	sta $0314 // Set interrupts vector
 	stx $0315 // Set interrupts vector
 	sty $d012 // Trigger interrupt at line $40
 	
 	lda $dc0d // ACK CIA 1 interrupts
 	lda $dd0d // ACK CIA 2 interrupts
 	asl $d019 // ACK VIC interrupts
 	
 	cli // Enable interrupts again
 	
 mainloop: 
 	jmp mainloop
 
 interrupt:
 	// TODO: Clean this mess up

 	lda $d016 // read screen control register 2
 	and $f8 // mask out old horizontal scroll bits
 	ora xscroll // mask in new horizontal scroll bits
 	sta $d016 // store it
	lda xscroll // where are we?
:break()
	cmp #$00 // are we done scrolling for this time?
	bne continue // if not, continue scrolling 1 more pixel
	
	// TODO: Move characters 
	lda #7
	sta xscroll
	jmp exit

continue:	
	dec xscroll

 	
	exit: 
 	asl $d019
 	pla
 	tay
 	pla
 	tax
 	pla
 	rti

xscroll: .byte $7