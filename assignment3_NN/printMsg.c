#include "stm32f4xx.h"
#include <string.h>

void printoutput(const int a)
{
	 char *str;
	 
	if(a==0){ str = "\n AND Truth Table  (x1, x2, x3, y)::\n"; }
	if(a==1){ str = "\n ORTruth Table  (x1, x2, x3, y)::\n"; }
	if(a==2){ str = "\n NAND Truth Table (x1, x2, x3, y)::\n"; }
	if(a==3){ str = "\n NOR Truth Table  (x1, x2, x3, y)::\n"; }
	if(a==4){ str = "\n NOT Truth Table  (x1 ,y)::\n"; }
	
	 while(*str != '\0'){
      ITM_SendChar(*str);
      ++str;
   }
	 return;}

	 
void printMsg(const int a)
{
	 char Msg[100];
	 char *ptr;
	 sprintf(Msg, "%x", a);
	 ptr = Msg ;
   while(*ptr != '\0'){
      ITM_SendChar(*ptr);
      ++ptr;
   }
}
void printMsg2p(const int a, const int b)
{
	 char Msg[100];
	 char *ptr;
	 sprintf(Msg, "%x ", a);
	 ptr = Msg ;
   while(*ptr != '\0')
	 {
      ITM_SendChar(*ptr);
      ++ptr;
   }
	 sprintf(Msg, "%x \n", b);
	 ptr = Msg ;
   while(*ptr != '\0')
	 {
      ITM_SendChar(*ptr);
      ++ptr;
   }
}

void printMsg4p(const int a, const int b, const int c, const int d)
{
	 char Msg[100];
	 char *ptr;
	
	 sprintf(Msg, "%x ", a);
	 ptr = Msg ;
   while(*ptr != '\0')
	 {
      ITM_SendChar(*ptr);
      ++ptr;
   }
	
	 sprintf(Msg, "%x ", b);
	 ptr = Msg ;
   while(*ptr != '\0')
	 {
      ITM_SendChar(*ptr);
      ++ptr;
   }
	 
	 sprintf(Msg, "%x ", c);
	 ptr = Msg ;
   while(*ptr != '\0')
	 {
      ITM_SendChar(*ptr);
      ++ptr;
   }

	 sprintf(Msg, "%x\n", d);
	 ptr = Msg ;
   while(*ptr != '\0')
	 {
      ITM_SendChar(*ptr);
      ++ptr;
	 }
}