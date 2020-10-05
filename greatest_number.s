     AREA     appcode, CODE, READONLY
     EXPORT __main
	 ENTRY 
__main  FUNCTION		         
        MOV R1, #11
	 MOV R2, #1
	 MOV R3, #9
	 CMP R2,R1
	 IT GT
	 MOVGT R5, R2
	 MOVLE R5, R1
	 CMP R5,R3
	 ITE GT
	 MOVGT R5,R5
	 MOVLE R5,R3 ; result is stored in R5
	 
stop B stop ; stop program		
     ENDFUNC
     END
