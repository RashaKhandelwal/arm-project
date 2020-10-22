     AREA     appcode, CODE, READONLY
     EXPORT __main
	 ENTRY 
__main  FUNCTION		         
        VLDR.F32   s1, = 5 ; s1 = x , the value of x = 5 here  
		VLDR.F32   s2, = 1   ; s2 = 1 , used for division of term in the implementation of log series
		VLDR.F32   s6, = 1   ; used for incrementing s2 each time by 1 
		VLDR.F32   s3, = 1	
	    MOV R2 , #01           ;r2 = 1  , used for loop
loop   CMP R2 , #0x010       
       BEQ  endloop         ; break loop  on 10th iteration    
                            ;1st iteration                                          2nd iteration (s5 contain --> x - (x2/2))       
	   VMUL.F32 s3, s3, s1   ;s3 = Xx1 =>5 x1 = 5    ,,, s3 = 5              	    ,s3 = 25x5 = 625 -->x3
	   VDIV.F32 s4, s3, s2   ;s4 = s3/s2 =>5/1 = 5  -->x/1 (1st term)               ,s4 = s3/s2 => 625/3 --> x3 /3  (3nd term)
	   VADD.f32 s5, s5, s4   ;s5 = s5+s4 =>0+5 = 5  -->x                    	    ,s5 = s5+s4 => x - (x2/2) + (x3 /3) 
	   VADD.F32 s2, s2, s6   ;s2 =s2+s6 => 1+1 =2                               	,s2 =s2+s6 => 3+1 =4  
       VMUL.F32 s3, s3, s1   ;s3 = s3Xs1 => 5x5 =25                            	    ,s3 = s3Xs1 => 625x5 =3125
	   VDIV.F32 s4, s3, s2   ;s4 = s3/s2 => 25/2  ->x2/2 (x2 is sqr of x)           ,s4 = s3/s2 => 3125/4 -->x4/4 (4th term)
	   VSUB.F32 s5, s5, s4   ;s5 = s5 -s4 =>    ---> x - (x2/2)                     ,s5 = s5 -s4 =>  x - (x2/2) + (x3 /3) - x4/4 
	   VADD.F32 s2, s2, s6   ;s2 =s2+s6 => 2+1 =3                                   ,s2 =s2+s6 =>4+1 =5  
	   ADD R2 ,R2 , #01      ; incrementing r2 for loop iteration
	   
	   B loop
endloop	 
stop    b stop		
     ENDFUNC
     END
 ; s5 updates the result after addition of new term  in each iteration
	   

		

