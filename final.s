     AREA     appcode, CODE, READONLY
     EXPORT __main
	 ENTRY 
__main  FUNCTION		         
        MOV R2, #0x02
		MOV R7, #0x03
		MOV R4, #0x04
		CMP R2 , R7	
		ITTE NE 
		SUBNE R2, R2 , R7
		MOVNE R2, #0x00
		ADDEQ R2, R2 ,R4
		MOVEQ R4, #0x00
stop    b stop		
     ENDFUNC
     END
