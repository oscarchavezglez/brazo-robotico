LIST P=18f45K50 		;directiva para definir el procesador
#include<p18F45k50.INC>		;definiciones de variables especificas del procesador
;*************************************************************************************
;Bits de configuración
CONFIG WDTEN = OFF 	;Temporizador vigia apagado    
CONFIG MCLRE = ON 	;Reset encendido
CONFIG DEBUG = OFF	; Disables Debug mode    
CONFIG LVP = OFF	; Disables Low-Voltage programming    
CONFIG FOSC = INTOSCIO	; Enables internal oscillator
CONFIG nPWRTEN = Off	;PWR UP Timer habilitado
;**************************************************************************************
org 000  
 XB EQU 0X00   
     
 MainLoop:
MOVLB  0xF0 
CLRF ANSELB
MOVLW  0x0F 
MOVWF TRISB 
BCF PORTB,0
CLRF TRISC ;Se configura el puerto C como salidas digitales con Trisc
;PWM periodo = (PR2 + 1)*4*Tosc*Prescaler
;PR2 = (PWM periodo/(4*Tosc*Prescaler))-1
;PR2 = (1/50Hz/(4*(1/500KHz)*16))-1    
;PR2 =155 --> Hex=9B      
MOVLW  0x9B   
MOVWF PR2      
;PWM Duty Cycle = (CCPRXL:CCPXCON<5:4>)*TOSC *(TMR2 Prescale Value)
;CCPRXL=PWM/(TOSC*(TMR2 Prescale Value))
;CCPRXL=((1/50Hz)/(1/500KHz)*16)
;CCPRXL=625
;T= -90°=0.5ms <---> 0°=1.5ms <--->  90°=2.5ms
;50%--->10ms
;X=?<---T   
;X --->  -90°=2.5% <---> 0°=7.5% <--->  90°=12.5%
;625--->100%
;Y=?<---X   
;Y --->  -90°=16 <---> 0°=47 <--->  90°=78    
;Y --->  -90°=00010000 <---> 0°=00101111 <--->  90°=01001110   
;Y --->  -90°=00000100 <---> 0°=11001011 <--->  90°=10010011    
MOVLW 0x10
MOVWF XB
INC       
BTFSC PORTB,0 ;  PORTB,0 "Bit 0" del puerto A esta en 0 lógico (0volts)?
INCF XB,f
MOVF XB,W
MOVWF CCPR1L 
MOVLW b'00000111' ;0000011 ;00000101 ;1:1 Postscaler ,Timer2 is on,Prescaler is 16 tablade registro
MOVWF T2CON
MOVLW b'00001100'; 00001100  ;CCPxCON: STANDARD CCPx CONTROL REGISTER 00001101
MOVWF CCP1CON    
MOVLW 0x00
MOVWF TMR2    
GOTO INC
 

 
 
 
END
    
    
    
    
    
    
  