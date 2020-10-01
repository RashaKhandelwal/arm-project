     AREA     appcode, CODE, READONLY
     EXPORT __main
	 ENTRY 
__main  FUNCTION		         
        MOV R2, #0x02
		MOV R7, #0x03
		MOV R4, #0x04
		CMP R2 , R7	
		ITTE LT 
		SUBLT R2, R2 , R7
		MOVLT R2, #0x00
		ADDGE R2, R2 ,R4
		MOVGE R4, #0x00
stop    b stop		
     ENDFUNC
     END
