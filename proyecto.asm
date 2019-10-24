LIST P=18f45K50 		;directiva para definir el procesador
#include<p18F45k50.INC>		;definiciones de variables especificas del procesador
;*************************************************************************************
;Bits de configuración
CONFIG WDTEN = OFF 	;Temporizador vigia apagado    
CONFIG MCLRE = ON 	;Reset encendido
CONFIG DEBUG = OFF	; Disables Debug mode    
CONFIG LVP = OFF	; Disables Low-Voltage programming    
CONFIG FOSC = INTOSCIO	; Enables internal oscillator
CONFIG nPWRTEN = ON	;PWR UP Timer habilitado
;**************************************************************************************
org 000
    
;PWM periodo = (PR2 + 1)*4*Tosc*Prescaler
;PR2 = (PWM periodo/(4*Tosc*Prescaler))-1
;PR2 = (1/50Hz/(4*(1/500KHz)*16))-1    
;PR2 =155 --> Hex=9B    
MOVLW  0x9B   
MOVWF PR2         
MOVLB  0xF0     
CLRF TRISC ;Se configura el puerto C como salidas digitales con Trisc  
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
;Y --->  -90°= <---> 0°=7.5% <--->  90°=12.5%    
    ;00000100
MOVLW b'00000100' ;-90°= 00100111 0°=11001011 90°=10010011
MOVWF CCPR1L 
        
   

    


    
MOVLW b'00000101' ;  00000111 original     ;0000 0011 ; 00000101
MOVWF T2CON
MOVLW b'00001101' ;00000000 ;00001101 ORIGINAL
MOVWF CCP1CON    
MOVLW 0x00
MOVWF TMR2
END
    
    
    
    
    
    
  