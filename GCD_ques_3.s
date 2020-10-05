     AREA     appcode, CODE, READONLY
     EXPORT __main
	 ENTRY 
__main  FUNCTION		         
     MOV R1,#6;a
	 MOV R2,#15;b
loop CMP R1,R2
     BEQ  endloop 
	 CMP R1 ,R2
     ITE GT
	 SUBGT R1,R1,R2 ; a > b 
	 SUBLE R2,R2,R1 ; b > a
	 B loop
endloop	 

stop B stop ; stop program		
     ENDFUNC
     END
