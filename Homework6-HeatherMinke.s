* Homework6 ARM Program Framework
	
	AREA	Homework6, CODE, READONLY
	EXPORT	main		;required by the startup code
	ENTRY

main					;required by the startup code. This is a label as well.
	MOV R7, #0			;moves the number 0 to R7
	LDR R2, =HCode - 1	;loads the memory address for HCode - 1 into R2
	MOV R3, #1			;moves the number 1 to R3
ErrDetect
	LDRB R6, [R2, R3]	;loads a byte from the memory location in R2 with an index of R3 to R6
	CMP R6, #'0'		;compares the contents of R6 with the ASCII of 0
	BEQ IsZero			;branches to IsZero when the contents of R6 is equal to the ASCII of 0
	CMP R6, #'1'		;compares the contents of R6 with the ASCII of 1
	BNE DoneErrDet		;branches to DoneErrDet if the contents of R6 is not equal to the ASCII of 1
	EOR R7, R3
IsZero
	ADD R3, #1			;adds 1 to the contents of R3
	B ErrDetect			;branches to ErrDetect
DoneErrDet
	CMP R7, #0x0		;compares the contents of R7 with the number 0
	BEQ NoParityErr		;branches to NoParityErr if the contents of R7 is equal to the number 0
	LDRB R6, [R2, R7]	;loads a byte from the memory location in R2 with an index of R7 to R6
	CMP R6, #'1'		;compares the contents of R6 to the ASCII of 1
	BEQ If1				;branches to If1 if the contents of R6 is equal to the ASCII of 1
	MOV R6, #'1'		;moves the ASCII of 1 to R6
	B Else1				;branches to Else1
If1	
	MOV R6, #'0'		;moves the ASCII of 0 to R6
Else1
	STRB R6, [R2, R7]	;stores a byte from the memory location in R2 with the index of R7 to R6
NoParityErr
	MOV R3, #1			;moves the number 1 to R3
	LDR R4, =SrcWord - 1;loads the memory location of SrcWord - 1 to R4
	MOV R5, #1			;moves the number 1 to R5
	MOV R8, #1			;moves the number 1 to R8
Loop
	LDRB R6, [R2, R3]	;loads a byte from the memory location in R2 with the index of R3 to R6
	CMP R6, #0x0		;compares the contents of R6 to the number 0
	BEQ DoneSrcWord		;branches to DoneSrcWord when the contents of R6 is equal to the number 0.
	CMP R8, R3			;compares the contents of R8 with the contents of R3
	BEQ InnerLoop		;branches to InnerLoop if the contents of R8 is equal to the contents of R3
	STRB R6, [R4, R5]	;stores a byte from the memory location R4 with the index of R5 to R6
	ADD R5, #1			;Adds the contents of R5 and 1
	B LoopEnd			;branches to LoopEnd
InnerLoop
	LSL R8, #1			;logic shift left of the contents of R8 by 1 bit. This is used to multiply by 2.
LoopEnd
	ADD R3, #1			;adds the contents of R3 and 1
	B Loop				;branches to Loop
DoneSrcWord
	MOV R6, #0			;moves the number 0 to R6
	STRB R6, [R4, R5]	;stores a byte from the memory location of R4 with the index of R5 to R6
	SVC	#0x11 			;this ends the main routine
	
	AREA	Homework6Data, DATA, READWRITE
		
	EXPORT	adrHCode		;needed for displaying addr in command-window
	EXPORT	adrSrcWord		;needed for displaying addr in command-window

adrHCode DCD HCode			;needed for displaying addr in command-window. DCD is for a four byte word.
adrSrcWord DCD SrcWord		;needed for displaying addr in command-window. DCD is for a four byte word.
	
HCode DCB "010011100101", 0		;this string holds the hem code.

	ALIGN

MAX_LEN EQU 100
SrcWord SPACE MAX_LEN
	
	END
