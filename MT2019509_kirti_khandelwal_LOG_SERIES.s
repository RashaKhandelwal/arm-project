     AREA     appcode, CODE, READONLY
     EXPORT __main
	 ENTRY 
__main  FUNCTION		         
        VLDR.F32   s1, = 10 ; s1 = x , the value of x = 10 here  
		VLDR.F32   s2, = 1   ; s2 = 1 , used for division of term in the implementation of log series
		VLDR.F32   s6, = 1   ; used for incrementing s2 each time by 1 
		VLDR.F32   s3, = 1	
	    MOV R2 , #01           ;r2 = 1  , used for loop
loop   CMP R2 , #0x010       
       BEQ  endloop                ; break loop  on 100th iteration    
                                   ;1st iteration                                          2nd iteration (s5 contain --> x - (x2/2))       
	   VMUL.F32 s3, s3, s1   ;s3 = Xx1 =>10x1 = 10    ,,, s3 = 10              	    ,s3 = 100x10 = 1000 -->x3
	   VDIV.F32 s4, s3, s2   ;s4 = s3/s2 =>10/1 = 10  -->x/1 (1st term)                 ,s4 = s3/s2 => 1000/3 --> x3 /3  (3nd term)
	   VADD.f32 s5, s5, s4   ;s5 = s5+s4 =>0+10 = 10  -->x                    	    ,s5 = s5+s4 => x - (x2/2) + (x3 /3) 
	   VADD.F32 s2, s2, s6   ;s2 =s2+s6 => 1+1 =2                               	    ,s2 =s2+s6 => 3+1 =4  
       VMUL.F32 s3, s3, s1   ;s3 = s3Xs1 => 10x10 =100                            	    ,s3 = s3Xs1 => 1000x10 =10000
	   VDIV.F32 s4, s3, s2   ;s4 = s3/s2 => 100/2 = 50 ->x2/2 (x2 is sqr of x)          ,s4 = s3/s2 => 10000/4 -->x4/4 (4th term)
	   VSUB.F32 s5, s5, s4   ;s5 = s5 -s4 => 10-50 = -40   ---> x - (x2/2)              ,s5 = s5 -s4 =>  x - (x2/2) + (x3 /3) - x4/4 
	   VADD.F32 s2, s2, s6   ;s2 =s2+s6 => 2+1 =3                                       ,s2 =s2+s6 =>4+1 =5  
	   ADD R2 ,R2 , #01      ; incrementing r2 for loop iteration
	   
	   B loop
endloop	 
stop    b stop		
     ENDFUNC
     END
 ; s5 updates the result after addition of new term  in each iteration
	   

		

