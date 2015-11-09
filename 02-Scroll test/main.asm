/* 
  02-Scroll test
  
  A small test program to test screen/text scrolling on the C64.
  
  pepzi 2015-11-09 
*/


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
 	
 	lda #<interrupt
 	ldx #>interrupt
 	ldy #$20
 	sta $0314 // Set interrupts vector
 	stx $0315 // Set interrupts vector
 	sty $d012 // Trigger interrupt at line $40
 	
 	lda $dc0d // ACK CIA 1 interrupts
 	lda $dd0d // ACK CIA 2 interrupts
 	asl $d019 // ACK VIC interrupts
 	
 	cli // Enable interrupts again
 	
 	ldx #00
 	lda #32
 clear_screen:
 	sta $0400, x
 	sta $0500, x
 	sta $0600, x
 	sta $0700, x
 	inx
 	bne clear_screen
 	
 mainloop: 
 	jmp mainloop
 
// ----- @Interrupt routine@ -----
 interrupt:
 	// TODO: Clean this mess up
 	lda $d016 // read screen control register 2
 	and $f8 // mask out old horizontal scroll bits
 	ora xscroll // mask in new horizontal scroll bits
 	sta $d016 // store it

	dec xscroll
	cmp #$00
	bne exit // it hasn't rolled over (we are still scrolling)

	// xscroll has rolled over, reset it to 7 and load next char
	lda #$7
	sta xscroll
	
	
//	lda xscroll // where are we?

//	cmp #$00 // are we done scrolling for this time?
//	bne continue // if not, continue scrolling 1 more pixel
	
	// TODO: Move characters 

	// line starts at $07C0
	// line ends at $07E6
    // new letter arrives at $07E7
loadtext:    
    ldx letter
	lda scrolltext, x
	bne continue
	sta letter
	tax
	lda scrolltext, x
	
continue:
    sta $07e7
    inc letter
    
    ldx #$c0
    ldy #$c1
    
movetext:
	lda $0700, y
	sta $0700, x
	inx
	iny
	tya
	cmp #$e8
	bne movetext


 	
	exit: 
 	asl $d019
 	pla
 	tay
 	pla
 	tax
 	pla
 	rti

// ----- @Data@ -----
xscroll: .byte $7
letter: .word 0

scrolltext:
	.import text "scroll.txt"
	.byte $00

// ----- @Scripts@ -----
.var brkFile = createFile("breakpoints.txt") 
.eval brkFile.writeln("ll \"main.vs\"")

.macro break() {
	.eval brkFile.writeln("break " + toHexString(*))
}