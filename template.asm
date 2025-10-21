List p=18f4520 
    #include<p18f4520.inc>
    CONFIG OSC = INTIO67
    CONFIG WDT = OFF
    org 0x00
    
    mod8 macro t, a, b
    MOVFF a, btemp3
    MOVFF b, btemp4
    CALL div8_impl
    MOVFF btemp3, t
    endm

    div8 macro t, a, b
    MOVFF a, btemp3
    MOVFF b, btemp4
    CALL div8_impl
    MOVFF btemp8, t
    endm

    shift_left8 macro t, x, y
    MOVFF y, btemp1
    MOVFF x, btemp0
    CALL shift_left8_impl
    MOVFF btemp0, t
    endm

    shift_right8 macro t, x, y
    MOVFF y, btemp1
    MOVFF x, btemp0
    CALL shift_right8_impl
    MOVFF btemp0, t
    endm

    add16 macro tl, th, al, ah, bl, bh
    MOVFF al, WREG
    ADDWF bl, 0
    MOVWF tl
    MOVFF ah, WREG
    ADDWFC bh, 0
    MOVWF th
    endm

    sub16 macro tl, th, al, ah, bl, bh
    MOVFF ah, WREG
    SUBWF bh, 0
    MOVWF th
    MOVFF al, WREG
    SUBWFB bl, 0
    MOVWF tl
    endm

    negf16 macro xl, xh
    NEGF xl, 1
    COMF xh, 1
    MOVLW 0x00
    ADDWFC xh, 1
    endm

    int8_to_int16 macro xo, xl, xh
    MOVFF xo, xl
    MOVLW 0x80
    ANDWF xo, 0
    IORWF xh, 1
    RRCF xh, 0
    IORWF xh, 1
    RRCF xh, 0
    RRCF WREG, 0
    IORWF xh, 1
    RRCF xh, 0
    RRCF WREG, 0
    RRCF WREG, 0
    RRCF WREG, 0
    IORWF xh, 1
    endm

    int16_to_int32 macro xol, xoh, x0, x1, x2, x3
    MOVFF xol, x0
    MOVFF xoh, x1
    MOVLW 0x80
    ANDWF xoh, 0
    IORWF x2, 1
    RRCF x2, 0
    IORWF x2, 1
    RRCF x2, 0
    RRCF WREG, 0
    IORWF x2, 1
    RRCF x2, 0
    RRCF WREG, 0
    RRCF WREG, 0
    RRCF WREG, 0
    IORWF x2, 1
    MOVFF x2, WREG
    IORWF x3, 1
    endm

    negf32 macro x0, x1, x2, x3
    negf16 x0, x1
    COMF x2, 1
    COMF x3, 1
    MOVLW 0x00
    ADDWFC x2, 1
    ADDWFC x3, 1
    endm

main:
    MOVLW 0xFE
    MOVWF 0x000

    MOVLW 0x08
    MOVWF 0x001
    shift_right8 0x002, 0x000, 0x001

    GOTO meow

    btemp0 EQU 0xF0
    btemp1 EQU 0xF1
    btemp2 EQU 0xF2
    btemp3 EQU 0xF3
    btemp4 EQU 0xF4
    btemp5 EQU 0xF5
    btemp6 EQU 0xF6
    btemp7 EQU 0xF7
    btemp8 EQU 0xF8
    btemp9 EQU 0xF9
    btemp10 EQU 0xFA
    btemp11 EQU 0xFB
    btemp12 EQU 0xFC
    btemp13 EQU 0xFD
    btemp14 EQU 0xFE
    btemp15 EQU 0xFF

shift_right8_impl:
    CLRF btemp2
    MOVLW 0x00
    CPFSGT btemp1
    GOTO shift_right8_end
shift_right8_loop:
    BCF STATUS, 0
    RRCF btemp0
    MOVFF STATUS, WREG
    IORWF btemp2, 1
    DECFSZ btemp1
    GOTO shift_right8_loop
shift_right8_end:
    MOVFF btemp2, STATUS
    RETURN

shift_left8_impl:
    CLRF btemp2
    MOVLW 0x00
    CPFSGT btemp1
    GOTO shift_left8_end
shift_left8_loop:
    BCF STATUS, 0
    RLCF btemp0
    MOVFF STATUS, WREG
    IORWF btemp2, 1
    DECFSZ btemp1
    GOTO shift_left8_loop
shift_left8_end:
    MOVFF btemp2, STATUS
    RETURN

div8_impl:
    MOVLW 0x07
    MOVWF btemp6
    MOVLW 0x80
    MOVWF btemp7
    CLRF btemp8
div8_loop:
    shift_left8 btemp5, btemp4, btemp6
    ; if carry != 0
    BTFSC STATUS, 0
    GOTO div8_loop_tail
    MOVFF btemp5, WREG
    CPFSLT btemp3
    GOTO div8_sub
    GOTO div8_loop_tail
div8_sub:
    SUBWF btemp3, 1
    MOVFF btemp7, WREG
    ADDWF btemp8, 1
div8_loop_tail:
    MOVLW 0x00
    CPFSGT btemp6
    GOTO div8_loop_end
    BCF STATUS, 0
    RRCF btemp7, 1
    DECF btemp6
    GOTO div8_loop
div8_loop_end:
    RETURN
    


meow:
    end


