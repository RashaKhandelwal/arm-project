     AREA     appcode, CODE, READONLY
     EXPORT __main
	 ENTRY 
__main  FUNCTION		         
		MOV     R8, #10   ; n = 10
        MOV     R0, #0      ; fn1 = 0
        MOV     R1, #1      ; fn = 1
        MOV     R7, #1      ; 
loop     CMP     R7, R8      ; while (r7 < 1)
        BHS     endloop      ; {
        ADD     R7, R7, #1    
        MOV     R3, R1      
        ADD     R1, R1, R0  ;   nextterm = fn + fn1
        MOV     R0, R3        
        B       loop         ;}
endloop
STOP    B       STOP

     
     ENDFUNC
     END
    