
	THUMB
	PRESERVE8
	AREA  appcode, CODE, READONLY
	IMPORT printMsg2p
	IMPORT printMsg4p
	IMPORT printoutput
	IMPORT find_exp
	EXPORT __main
	ENTRY

__main FUNCTION
	 
	 MOV R0,#0;					 (AND Gate)
	 BL printoutput;	
	 BL compute_and;
	 
	 MOV R0,#1;					(OR Gate)
	 BL printoutput;
	 BL compute_or;	
	 
	 MOV R0,#2;					 (NAND Gate)
	 BL printoutput;	
	 BL compute_nand;
	 
	 MOV R0,#3;					 (NOR Gate)
	 BL printoutput;	
	 BL compute_nor;
	 
	 MOV R0,#4;					 (NOT Gate)
	 BL printoutput;	
	 BL compute_not;
	 
stop B stop
 
	 ENDFUNC	

;#############################################################################

find_sigmoid FUNCTION
	 
	 ; Calculate  e^-x in S7 , Sigmoid func output in S9
	 
	 PUSH {LR}
	 VLDR.F32 S8, =1			
	 VADD.F32 S9, S7, S8			; compute (e^-x)+1
	 VDIV.F32 S9, S8, S9			; S9 = 1/(e^-x)+1
	 POP {LR};	
	 BX lr;
	 
	ENDFUNC
;#############################################################################


compute_sigmoid FUNCTION
	 PUSH {LR}
	 BL find_exp						; Compute e^-x
	 BL find_sigmoid					; Sigmoid function output in S9
	 
	 VLDR.F32 S10, =0.5				;setting threshold 0.5
	 VCMP.F32 S9,S10				; Compare Sigmoid funct output with 0.5		
	 VMRS    APSR_nzcv, FPSCR;
	 MOV R0, R4;
	 MOV R1, R5;
	 MOV R2, R6;
	 MOVGT	R3, #1					; If y > 0.5, output is 1
	 MOVLT	R3, #0					; If y < 0.5, output is 0
	 POP {LR}
	 BX lr
	 
	 ENDFUNC	 
	 
;#############################################################################

;r4 have contain x1(input1)
;r5 have contain x2(input2)
;r6 have contain x3(input3)

load_FPU_reg FUNCTION
	; loads the FPU registers with the activation inputs of the NN
	
	 PUSH {LR};
	 
	 VMOV.F32 S0,R4;			move x1 to S0 
     VCVT.F32.S32 S0,S0; 		
	 VMOV.F32 S1,R5;			move x2 to S1 
     VCVT.F32.S32 S1,S1; 		
	 VMOV.F32 S2,R6;			move x3 to S2 
     VCVT.F32.S32 S2,S2; 		
	 POP {LR};
	 
	 BX lr;
	 ENDFUNC
	 
;#####################AND_GATE############################


__logic_and FUNCTION
	 PUSH {LR};	 
	 VLDR.F32 S4, =-0.1		    ; W1
	 VLDR.F32 S5, =0.2			; W2
	 VLDR.F32 S6, =0.2		    ; W3
	 VLDR.F32 S7, =-0.2			; Bias
	 
	 VMUL.F32 S0, S0, S4			; x1*W1
	 VMUL.F32 S1, S1, S5			; x2*W2
	 VMUL.F32 S2, S2, S6			; x3*W3
	 VADD.F32 S3, S0, S1			; x1*W1 + x2*W2 
	 VADD.F32 S3, S3, S2			; x1*W1 + x2*W2 + x3*W3 
	 VADD.F32 S3, S3, S7			; z = x1*W1 + x2*W2 + x3*W3 + Bias
	 
	 VNEG.F32 S3, S3
	 VMOV.F32 S0, S3				; move z to S0
	 BL compute_sigmoid;
	 LTORG
	 POP {LR};	
	 BX lr;
	 ENDFUNC

;#####################OR_GATE############################

__logic_or FUNCTION
	 PUSH {LR};	 
	 VLDR.F32 S4,=-0.1				; W1
	 VLDR.F32 S5,=0.7				; W2
	 VLDR.F32 S6,=0.7			    ; W3
	 VLDR.F32 S7,=-0.1				; Bias
	 
	 VMUL.F32 S0,S0,S4				; x1*W1
	 VMUL.F32 S1,S1,S5				; x2*W2
	 VMUL.F32 S2,S2,S6				; x3*W3
	 VADD.F32 S3,S0,S1				; x1*W1 + x2*W2 
	 VADD.F32 S3,S3,S2				; x1*W1 + x2*W2 + x3*W3 
	 VADD.F32 S3,S3,S7				; z = x1*W1 + x2*W2 + x3*W3 + Bias
	 
	 VNEG.F32 S3, S3
	 VMOV.F32 S0, S3				;move z to S0
	 BL compute_sigmoid;
	 LTORG
	 POP {LR};	
	 BX lr;
	 ENDFUNC
	 
		;#####################NOT_GATE############################	

__logic_not FUNCTION
	 PUSH {LR};	 
	 VLDR.F32 S4,= 0.5;  w1   
     VLDR.F32 S5,= -0.7				; W2
	 VLDR.F32 S6,=0		 ;w3
	 VLDR.F32 S7,= 0.1;			Bias
 
	 VMUL.F32 S0, S0, S4			; x1*W1
	 VMUL.F32 S1, S1, S5			; x2*W2
	 VMUL.F32 S2, S2, S6			; x3*W3
	 VADD.F32 S3, S0, S1			; x1*W1 + x2*W2 
	 VADD.F32 S3, S3, S2			; x1*W1 + x2*W2 + x3*W3 
	 VADD.F32 S3, S3, S7			; z = x1*W1 + x2*W2 + x3*W3 + Bias
	 
	 VNEG.F32 S3, S3
	 VMOV.F32 S0, S3	             ;move z to S0
	 BL compute_sigmoid;
	 POP {LR};	
	 BX lr;
	 ENDFUNC



	;#####################NAND_GATE############################

__logic_nand FUNCTION
	 PUSH {LR}
	 VLDR.F32 S4, =0.6				; W1
	 VLDR.F32 S5, =-0.8				; W2
	 VLDR.F32 S6, =-0.8				; W3
	 VLDR.F32 S7, =0.3				; Bias
	                            
	 VMUL.F32 S0, S0, S4			; x1*W1
	 VMUL.F32 S1, S1, S5			; x2*W2
	 VMUL.F32 S2, S2, S6			; x3*W3
	 VADD.F32 S3, S0, S1			; x1*W1 + x2*W2 
	 VADD.F32 S3, S3, S2			; x1*W1 + x2*W2 + x3*W3 
	 VADD.F32 S3, S3, S7			; z = x1*W1 + x2*W2 + x3*W3 + Bias
	                            
	 VNEG.F32 S3, S3            
	 VMOV.F32 S0, S3;				; move z to S0
	 BL compute_sigmoid;
	 LTORG
	 POP {LR}
	 BX lr
	 ENDFUNC

;#####################NOR_GATE############################

__logic_nor FUNCTION
	 PUSH {LR} 
	 VLDR.F32 S4, =0.5				; W1
	 VLDR.F32 S5, =-0.7				; W2
	 VLDR.F32 S6, =-0.7				; W3
	 VLDR.F32 S7, =0.1				; Bias
	                            
	 VMUL.F32 S0, S0, S4			; x1*W1
	 VMUL.F32 S1, S1, S5			; x2*W2
	 VMUL.F32 S2, S2, S6			; x3*W3
	 VADD.F32 S3, S0, S1			; x1*W1 + x2*W2 
	 VADD.F32 S3, S3, S2			; x1*W1 + x2*W2 + x3*W3 
	 VADD.F32 S3, S3, S7			;z = x1*W1 + x2*W2 + x3*W3 + Bias
	          
	 VNEG.F32 S3, S3   
	 VMOV.F32 S0, S3				; move z to S0
	 BL compute_sigmoid           
	 POP {LR}	
	 BX lr
	 ENDFUNC
	  		 
;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Truth Tables   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^  
compute_and FUNCTION
;3 input  and gate	
	
	 PUSH {LR}; 
	 MOV R4,#0;					x1	
	 MOV R5,#0;					x2	
	 MOV R6,#0;					x3	
	 BL load_FPU_reg;
	 BL __logic_and;
	 BL printMsg4p
	 
	 MOV R4,#1;					x1	
	 MOV R5,#0;					x2	
	 MOV R6,#1;					x3	
	 BL load_FPU_reg;
	 BL __logic_and;
	 BL printMsg4p
	 
	 MOV R4,#1;					x1	
	 MOV R5,#1;					x2	
	 MOV R6,#0;					x3	
	 BL load_FPU_reg;
	 BL __logic_and;
	 BL printMsg4p
	 
	 MOV R4,#1;					x1	
	 MOV R5,#1;					x2	
	 MOV R6,#1;					x3	
	 BL load_FPU_reg;
	 BL __logic_and;
	 BL printMsg4p
	 
	 POP {LR};	
     BX lr;						
	 					
	 ENDFUNC 
;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^		 
compute_or FUNCTION	
;3 input  or gate	
	 PUSH {LR}; 
	 MOV R4,#0;					x1
	 MOV R5,#0;					x2
	 MOV R6,#0;					x3
	 BL load_FPU_reg;
	 BL __logic_or;
	 BL printMsg4p
	 
	 MOV R4,#1;					x1
	 MOV R5,#0;					x2
	 MOV R6,#1;					x3
	 BL load_FPU_reg;
	 BL __logic_or;
	 BL printMsg4p
	 
	 MOV R4,#1;					x1
	 MOV R5,#1;					x2
	 MOV R6,#0;					x3
	 BL load_FPU_reg;
	 BL __logic_or;
	 BL printMsg4p
	 
	 MOV R4,#1;					x1
	 MOV R5,#1;					x2
	 MOV R6,#1;					x3
	 BL load_FPU_reg;
	 BL __logic_or;
	 BL printMsg4p
	 
	 POP {LR};	
     BX lr;						
	 					
	 ENDFUNC 

;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^		 
	 
compute_nand FUNCTION	
;3 input  nand gate	

	 PUSH {LR}; 
	 MOV R4,#0;					x1
	 MOV R5,#0;					x2
	 MOV R6,#0;					x3
	 BL load_FPU_reg; 
	 BL __logic_nand; 
	 BL printMsg4p;
	 
	 MOV R4,#1;					x1
	 MOV R5,#0;					x2
	 MOV R6,#1;					x3
	 BL load_FPU_reg; 
	 BL __logic_nand; 
	 BL printMsg4p;
	 
	 MOV R4,#1;					x1
	 MOV R5,#1;					x2
	 MOV R6,#0;					x3
	 BL load_FPU_reg; 
	 BL __logic_nand; 
	 BL printMsg4p;
	 
	 MOV R4,#1;					x1
	 MOV R5,#1;					x2
	 MOV R6,#1;					x3
	 BL load_FPU_reg; 
	 BL __logic_nand; 
	 BL printMsg4p;
	 
	 POP {LR};	
     BX lr;						
	 					
	 ENDFUNC 
;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^		 
compute_nor FUNCTION	
;3 input  nor gate

	 PUSH {LR}; 
	 MOV R4,#0;					x1	
	 MOV R5,#0;					x2	
	 MOV R6,#0;					x3	
	 BL load_FPU_reg; 
	 BL __logic_nor; 
	 BL printMsg4p;
	 
	 MOV R4,#1;					x1	
	 MOV R5,#0;					x2	
	 MOV R6,#1;					x3	
	 BL load_FPU_reg; 
	 BL __logic_nor; 
	 BL printMsg4p;
	 
	 MOV R4,#1;					x1
	 MOV R5,#1;					x2
	 MOV R6,#0;					x3
	 BL load_FPU_reg; 
	 BL __logic_nor; 
	 BL printMsg4p;
	 
	 MOV R4,#1;					x1
	 MOV R5,#1;					x2
	 MOV R6,#1;					x3
	 BL load_FPU_reg; 
	 BL __logic_nor; 
	 BL printMsg4p;
	 
	 POP {LR};	
     BX lr;						
	 					
	 ENDFUNC 
;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^		 
compute_not FUNCTION	

	 PUSH {LR}; 
	 MOV R4,#0;					x1	
	 MOV R5,#0;					x2	
	 MOV R6,#0;					x1
	 BL load_FPU_reg; 
	 BL __logic_not; 
	 BL printMsg4p;
	 
	 
	 MOV R4,#1;					
	 MOV R5,#1;					
	 MOV R6,#1;						
	 BL load_FPU_reg; 
	 BL __logic_not; 
	 BL printMsg4p;
	 
	 POP {LR};	
     BX lr;				
	 					
	 ENDFUNC  

;**************************************************************************
	 
	END