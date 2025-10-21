List p=18f4520 
    #include<p18f4520.inc>
    CONFIG OSC = INTIO67
    CONFIG WDT = OFF
    org 0x00

    for macro i, num, for_loop_label, for_end_label
for_loop_label:
    MOVFF num, WREG
    CPFSLT i
    GOTO for_end_label

    endm

    for_end macro i, for_loop_label, for_end_label
    INCF i
    GOTO for_loop_label
for_end_label:
    endm

    
    if_equ macro a, b, if_label, else_label
    MOVFF a, WREG
    CPFSEQ b
    GOTO else_label
    GOTO if_label
if_label:

    endm

    else_ macro else_label, end_if_label
    GOTO end_if_label
else_label:


    endm

    end_if macro end_if_label
end_if_label:
    endm

    if_bigger macro a, b, if_label, else_label
    MOVFF b, WREG
    CPFSGT a
    GOTO else_label
    GOTO if_label
if_label:

    endm

    if_lower macro a, b, if_label, else_label
    MOVFF b, WREG
    CPFSLT a
    GOTO else_label
    GOTO if_label
if_label:

    endm

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

    clz8 macro t, x
    MOVFF x, btemp0
    CALL clz8_impl
    MOVFF btemp1, t
    endm

    sqrt8 macro t, x
    MOVFF x, btemp3
    CALL sqrt8_impl
    MOVFF btemp4, t
    endm


    rlcf16 macro xl, xh
    RLCF xl, 1
    RLCF xh, 1
    endm

    rrcf16 macro xl, xh
    RRCF xh, 1
    RRCF xl, 1
    endm

    rlcf32 macro x0, x1, x2, x3
    rlcf16 x0, x1
    rlcf16 x2, x3
    endm

    rrcf32 macro x0, x1, x2, x3
    rrcf16 x2, x3
    rrcf16 x0, x1
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
    MOVLW 0x0F
    MOVWF 0x000
    MOVLW 0x00
    MOVWF 0x001
    if_lower 0x000, 0x001, if_label_1, else_label_1
    MOVLW 0x01
    MOVWF 0x002
    else_ else_label_1, end_if_label_1
    MOVLW 0xFF
    MOVWF 0x002
    end_if end_if_label_1

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
    
clz8_impl:
    MOVLW 0x08 ;if x == 0
    MOVWF btemp1

    CLRF WREG
    CPFSEQ btemp0
    GOTO clz8_START
    GOTO clz8_Continue3

clz8_START:
    CLRF btemp1

    MOVLW 0x10
    CPFSLT btemp0 ;c = (x < 0x10) << 2
    GOTO clz8_Continue1
    MOVLW 0x04
    ADDWF btemp1 ; r += c
    RLCF btemp0  ; x << c
    RLCF btemp0
    RLCF btemp0
    RLCF btemp0
clz8_Continue1:
    MOVLW 0x40
    CPFSLT btemp0 ;c = (x < 0x10) << 1
    GOTO clz8_Continue2
    MOVLW 0x02
    ADDWF btemp1 ; r += c
    RLCF btemp0  ; x << c
    RLCF btemp0
clz8_Continue2:
    MOVLW 0x80
    CPFSLT btemp0 ;c = (x < 0x10) << 1
    GOTO clz8_Continue3
    MOVLW 0x01
    ADDWF btemp1 ; r += c
    RLCF btemp0  ;x << c
clz8_Continue3:
    RETURN

; https://hackmd.io/@sysprog/linux2025-quiz2#%E6%B8%AC%E9%A9%97-2
; why it work: https://hackmd.io/@sysprog/linux2025-quiz2#%E6%B8%AC%E9%A9%97-2
sqrt8_impl:
    CLRF btemp4 ; y
    ; if (x <= 1)
    MOVLW 0x01
    CPFSGT btemp3
    GOTO sqrt8_x_lower_1

    ; shift = (total_bits - 1 - clz8(x)) & ~1;
    clz8 btemp0, btemp3
    MOVLW 0x07
    SUBWF btemp0, 1
    NEGF btemp0, 1
    MOVLW 0xFE
    ANDWF btemp0, 1


    MOVLW 0x01
    shift_left8 btemp5, WREG, btemp0 ;m

    
sqrt8_loop:
    ; while (m)
    CLRF WREG
    CPFSGT btemp5
    GOTO sqrt8_end

    ; b = y + m
    MOVFF btemp4, WREG
    ADDWF btemp5, 0
    ; y >>= 1
    BCF STATUS, 0
    RRCF btemp4, 1

    ; if (x >= b)
    CPFSLT btemp3
    GOTO sqrt8_process
    GOTO sqrt8_continue
sqrt8_process:
    SUBWF btemp3, 1
    MOVFF btemp5, WREG
    ADDWF btemp4, 1
sqrt8_continue:
    ; m >>= 2
    BCF STATUS, 0
    RRCF btemp5, 1
    BCF STATUS, 0
    RRCF btemp5, 1
    GOTO sqrt8_loop

sqrt8_end:
    RETURN
sqrt8_x_lower_1:
    MOVFF btemp3, btemp4
    RETURN

meow:
    end


