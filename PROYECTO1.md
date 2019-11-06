# brazo-robotico
pic18f45k50
LIST P=18f45K50 		;directiva para definir el procesador
#include<p18F45k50.INC>		;definiciones de variables especificas del procesador
;*************************************************************************************
;Bits de configuración
CONFIG WDTEN = OFF 	;Temporizador vigia apagado    
CONFIG MCLRE = ON 	;Reset encendido
CONFIG DEBUG = OFF	; Disables Debug mode    
CONFIG LVP = OFF	; Disables Low-Voltage programming    
CONFIG FOSC = INTOSCIO	; Enables internal oscillator 
CONFIG nPWRTEN = OFF	;PWR UP Timer habilitado
;**************************************************************************************
org 000  
XB EQU 0x00
XS EQU 0x01

MOVLB 0xF ; Set BSR for banked SFRs
MOVLW 0X1F ;PONER LOS BITS<0Y2>COMO ENTRADAS
MOVWF TRISB 
CLRF LATB
MOVLW 0X00
MOVWF ANSELB
SETF PORTB
CLRF TRISC ;Se configura el puerto C como salidas digitales con Trisc	
   
MOVLW  0x9B   ;0x9B 
MOVWF PR2      
  
MOVLW 0x0F
MOVWF XB
MOVLW 0x0F
MOVWF XS 

MOVLW b'00100011' ; Configures OSCCON register    
MOVWF OSCCON  
MOVLW b'00000111' ;0000011 ;00000101 ;1:1 Postscaler ,Timer2 is on,Prescaler is 16 tablade registro
MOVWF T2CON
MOVLW b'00001100'; 00001100  ;CCPxCON: STANDARD CCPx CONTROL REGISTER 00001101
MOVWF CCP1CON 
MOVLW b'00001100'; 00001100  ;CCPxCON: STANDARD CCPx CONTROL REGISTER 00001101
MOVWF CCP2CON
 
PROCESO ; Título del proceso
CALL TESTEAARRIBAX ; LLama a probar el boton de incremento
CALL TESTEAABAJOX; Llama a probar el boton de decremento
CALL TESTEAARRIBAY ; LLama a probar el boton de incremento
CALL TESTEAABAJOY; Llama a probar el boton de decremento 
CALL TESTEACERO ; LLama a probar el boton de incremento
GOTO PROCESO ; Hace el buble del proceso

TESTEAARRIBAX ; titulo de prueba del boton de incremento
BTFSS PORTB,0 ; ¿El pin 0 del puerto A es = 1 (está presionado)?
RETURN; Caso Falso regresa a donde lo llamó
CALL CONFIRMAARRIBAX; Caso verdadero, Llama a confirmacion
RETURN; Regresa a donde lo llamó

TESTEAABAJOX ; Título de prueba del boton de decremento
BTFSS PORTB,2 ; ¿El pin 2 del puerto A es = 1 (Esta presionado)?
RETURN; Caso falso. Regresa a donde lo llamó
CALL CONFIRMAABAJOX; Caso verdadero. Llama a confirmación
RETURN; Regresa a donde lo llamó

TESTEAARRIBAY ; titulo de prueba del boton de incremento
BTFSS PORTB,3 ; ¿El pin 0 del puerto A es = 1 (está presionado)?
RETURN; Caso Falso regresa a donde lo llamó
CALL CONFIRMAARRIBAY; Caso verdadero, Llama a confirmacion
RETURN; Regresa a donde lo llamó

TESTEAABAJOY ; Título de prueba del boton de decremento
BTFSS PORTB,4 ; ¿El pin 2 del puerto A es = 1 (Esta presionado)?
RETURN; Caso falso. Regresa a donde lo llamó
CALL CONFIRMAABAJOY; Caso verdadero. Llama a confirmación
RETURN; Regresa a donde lo llamó
  
TESTEACERO
BTFSS PORTB,1 ; ¿El pin 0 del puerto A es = 1 (está presionado)?
RETURN; Caso Falso regresa a donde lo llamó
CALL CONFIRMACERO; Caso verdadero, Llama a confirmacion
RETURN; Regresa a donde lo llamó
 
CONFIRMACERO; Confirmación de Subida
BTFSC PORTB,1; ¿El pin 0 del puerto A =0 (Ha sido soltado)?
GOTO CONFIRMACERO; Caso falso, bucle de confirmación
CALL CERO; Caso Verdadero. Llama al titulo de la accion incremento
RETURN; Regresa a donde lo llamó
 
CONFIRMAARRIBAX; Confirmación de Subida
BTFSC PORTB,0; ¿El pin 0 del puerto A =0 (Ha sido soltado)?
GOTO CONFIRMAARRIBAX; Caso falso, bucle de confirmación
CALL INCREMENTAX; Caso Verdadero. Llama al titulo de la accion incremento
RETURN; Regresa a donde lo llamó

CONFIRMAABAJOX ; Confirmación de Bajada
BTFSC PORTB,2; El pin 2 del puerto A=0(Ha sido soltado)?
GOTO CONFIRMAABAJOX; Caso falso. Bucle de confirmación
CALL DECREMENTAX; Caso Verdadero. Llama al título de la accion decremento
RETURN; Regresa a donde lo llamó

INCREMENTAX; Titulo de acción de Incremento
INCF XB,F ; Incrementa en 1 el valor del puerto B. y lo muestra ahi mismo a=1
MOVF XB,W
MOVWF CCPR1L
RETURN; Regresa a donde lo llamó

DECREMENTAX; Título de acción de Decremento
DECF XB,F; Decrementa en 1 el valor del puerto B y lo muestra ahí mismo a=1
MOVF XB,W
MOVWF CCPR1L
RETURN; Regresa a donde lo llamó
 
CERO; Título de acción de Decremento
MOVLW 0x02
MOVWF CCPR1L
MOVLW 0x02
MOVWF CCPR2L 
RETURN; Regresa a donde lo llamó 
	
CONFIRMAARRIBAY; Confirmación de Subida
BTFSC PORTB,3; ¿El pin 0 del puerto A =0 (Ha sido soltado)?
GOTO CONFIRMAARRIBAY; Caso falso, bucle de confirmación
CALL INCREMENTAY; Caso Verdadero. Llama al titulo de la accion incremento
RETURN; Regresa a donde lo llamó

CONFIRMAABAJOY ; Confirmación de Bajada
BTFSC PORTB,4; El pin 2 del puerto A=0(Ha sido soltado)?
GOTO CONFIRMAABAJOY; Caso falso. Bucle de confirmación
CALL DECREMENTAY; Caso Verdadero. Llama al título de la accion decremento
RETURN; Regresa a donde lo llamó

INCREMENTAY; Titulo de acción de Incremento
INCF XS,F ; Incrementa en 1 el valor del puerto B. y lo muestra ahi mismo a=1
MOVF XS,W
MOVWF CCPR2L
RETURN; Regresa a donde lo llamó

DECREMENTAY; Título de acción de Decremento
DECF XS,F; Decrementa en 1 el valor del puerto B y lo muestra ahí mismo a=1
MOVF XS,W
MOVWF CCPR2L
RETURN; Regresa a donde lo llamó
 
END
