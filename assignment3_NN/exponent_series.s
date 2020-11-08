	AREA appcode, CODE, READONLY
	EXPORT find_exp
	ENTRY

find_exp FUNCTION
;get e^-x in S5	
	;VLDR.F32 S0, =1				; x
	VLDR.F32 S1, =1					; current term
	VLDR.F32 S2, =20				; total iteration
	VMOV.F32 S3, S0					; moving x to compute next term in each iteration
	VLDR.F32 S4, =1					
	VLDR.F32 S6, =1					; loop increment counter
	VLDR.F32 S7, =1
	
loop
	VDIV.F32 S5, S3, S4				; calculate (x^n/n!)
	VADD.F32 S7, S7, S5				; adding this to previous term stored
	VADD.F32 S1, S1, S6				; updating current term index
	VMUL.F32 S3, S3, S0				; updating numerator by multiplying by 'x'
	VMUL.F32 S4, S4, S1				; computing factorial in each iteration
	VCMP.F32 S1, S2					
	VMRS APSR_nzcv, FPSCR			; floating-point status flags are transferred into the corresponding flags in the ARM APSR.
	BNE loop						;  exit when condition is not satisfied

	BX LR
	
	ENDFUNC
	END
; S0 -> input ->x
; S7 -> output		