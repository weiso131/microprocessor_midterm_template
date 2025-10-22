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

    if_equ16 macro al, ah, bl, bh, if_label, else_label
    MOVFF bh, WREG
    CPFSEQ ah
    GOTO else_label
    MOVFF bl, WREG
    CPFSEQ al
    GOTO else_label
if_label:

    endm

    if_equ_zero_16 macro al, ah, if_label, else_label
    CLRF WREG
    CPFSEQ ah
    GOTO else_label
    CPFSEQ al
    GOTO else_label
if_label:

    endm

    if_lower16 macro al, ah, bl, bh, if_label, else_label, middle_label
    MOVFF bh, WREG
    CPFSEQ ah
    GOTO middle_label
    MOVFF bl, WREG
    CPFSLT al
    GOTO else_label
    GOTO if_label
middle_label:
    CPFSLT ah
    GOTO else_label
    GOTO if_label
if_label:

    endm

    if_bigger16 macro al, ah, bl, bh, if_label, else_label, middle_label
    MOVFF bh, WREG
    CPFSEQ ah
    GOTO middle_label
    MOVFF bl, WREG
    CPFSGT al
    GOTO else_label
    GOTO if_label
middle_label:
    CPFSGT ah
    GOTO else_label
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

    shift_left16 macro tl, th, xl, xh, y
    MOVFF y, btemp2
    MOVFF xh, btemp1
    MOVFF xl, btemp0
    CALL shift_left16_impl
    MOVFF btemp0, tl
    MOVFF btemp1, th
    endm

    shift_right16 macro tl, th, xl, xh, y
    MOVFF y, btemp2
    MOVFF xh, btemp1
    MOVFF xl, btemp0
    CALL shift_right16_impl
    MOVFF btemp0, tl
    MOVFF btemp1, th
    endm

    div16 macro tl, th, al, ah, bl, bh
    MOVFF al, btemp4
    MOVFF ah, btemp5
    MOVFF bl, btemp6
    MOVFF bh, btemp7
    CALL div16_impl
    MOVFF btemp11, tl
    MOVFF btemp12, th

    endm
    
    mod16 macro tl, th, al, ah, bl, bh
    MOVFF al, btemp4
    MOVFF ah, btemp5
    MOVFF bl, btemp6
    MOVFF bh, btemp7
    CALL div16_impl
    MOVFF btemp4, tl
    MOVFF btemp5, th

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

    clz16 macro t, xl, xh
    MOVFF xl, btemp0
    MOVFF xh, btemp1
    CALL clz16_impl
    MOVFF btemp2, t
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
    MOVFF bl, WREG
    SUBWF al, 0
    MOVWF tl
    MOVFF bh, WREG
    SUBWFB ah, 0
    MOVWF th
    endm

    mul16 macro tl, tml, tmh, th, al, ah, bl, bh
    MOVF al, W
    MULWF bl
    MOVFF PRODL, tl
    MOVFF PRODH, tml
    MOVF al, W
    MULWF bh
    MOVF PRODL, W 
    ADDWF tml, F
    MOVF PRODH, W
    ADDWFC tmh, F
    MOVLW 0x00
    ADDWFC th
    MOVF bl, W
    MULWF ah
    MOVF PRODL, W 
    ADDWF tml, F
    MOVF PRODH, W
    ADDWFC tmh, F
    MOVLW 0x00
    ADDWFC th
    MOVF ah, W
    MULWF bh
    MOVF PRODL, W
    ADDWF tmh, F
    MOVF PRODH, W
    ADDWFC th, F
    endm

    negf16 macro xl, xh
    NEGF xl, 1
    COMF xh, 1
    MOVLW 0x00
    ADDWFC xh, 1
    endm

    sqrt16 macro t, xl, xh
    MOVFF xl, xl_sqrt16
    MOVFF xh, xh_sqrt16
    CALL sqrt16_impl
    MOVFF yl_sqrt16, t
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
    MOVLW 0x00
    MOVWF 0x000
    MOVLW 0x01
    MOVWF 0x001

    sqrt16 2, 0, 1
    
    MOVLW 0x01
    MOVWF 0x004
    CLRF 0x003
    MOVLW 0x03
    MOVWF 0x005
    CLRF 0x006

    div16 7, 8, 3, 4, 5, 6

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

shift_right16_impl:
    CLRF btemp3
    MOVLW 0x00
    CPFSGT btemp2
    GOTO shift_right16_end
shift_right16_loop:
    BCF STATUS, 0
    rrcf16 btemp0, btemp1
    MOVFF STATUS, WREG
    IORWF btemp3, 1
    DECFSZ btemp2
    GOTO shift_right16_loop
shift_right16_end:
    MOVFF btemp3, STATUS
    RETURN

shift_left16_impl:
    CLRF btemp3
    MOVLW 0x00
    CPFSGT btemp2
    GOTO shift_left16_end
shift_left16_loop:
    BCF STATUS, 0
    rlcf16 btemp0, btemp1
    MOVFF STATUS, WREG
    IORWF btemp3, 1
    DECFSZ btemp2
    GOTO shift_left16_loop
shift_left16_end:
    MOVFF btemp3, STATUS
    RETURN

div16_impl:
    ; (btemp5 btemp4) / (btemp7 btemp6)

    ; shift cnt
    MOVLW 0x0F
    MOVWF btemp8

    ; result adder
    MOVLW 0x80
    MOVWF btemp10
    CLRF btemp9

    ; result
    CLRF btemp11
    CLRF btemp12

    ; tmp
    ; btemp13
    ; btemp14
div16_loop:
    shift_left16 btemp13, btemp14, btemp6, btemp7, btemp8
    ; if carry != 0
    BTFSC STATUS, 0
    GOTO div16_loop_tail

    if_bigger16 btemp13, btemp14, btemp4, btemp5, if_label_div16_1, else_label_div16_1, middle_label_div16_1
    else_ else_label_div16_1, end_if_label_div16_1
    sub16 btemp4, btemp5, btemp4, btemp5, btemp13, btemp14
    add16 btemp11, btemp12, btemp11, btemp12, btemp9, btemp10
    end_if end_if_label_div16_1
div16_loop_tail:
    MOVLW 0x00
    CPFSGT btemp8
    GOTO div16_loop_end
    BCF STATUS, 0
    rrcf16 btemp9, btemp10
    DECF btemp8
    GOTO div16_loop
div16_loop_end:
    RETURN

clz16_impl:
    MOVLW 0x10 ;if x == 0
    MOVWF btemp2

    if_equ_zero_16 btemp0, btemp1, if_label_clz16_1, else_label_clz16_1
    GOTO clz16_Continue4
    else_ else_label_clz16_1, end_if_label_clz16_1
    end_if end_if_label_clz16_1

clz16_START:
    CLRF btemp2
    MOVLW 0x01
    CPFSLT btemp1 ;c = (x < 0x0100) << 3
    GOTO clz16_Continue1
    MOVLW 0x08
    ADDWF btemp2 ; r += c
    rlcf16 btemp0, btemp1 ; x << c
    rlcf16 btemp0, btemp1
    rlcf16 btemp0, btemp1
    rlcf16 btemp0, btemp1
    rlcf16 btemp0, btemp1
    rlcf16 btemp0, btemp1
    rlcf16 btemp0, btemp1
    rlcf16 btemp0, btemp1
clz16_Continue1:
    MOVLW 0x10
    CPFSLT btemp1 ;c = (x < 0x1000) << 2
    GOTO clz16_Continue2
    MOVLW 0x04
    ADDWF btemp2 ; r += c
    rlcf16 btemp0, btemp1 ; x << c
    rlcf16 btemp0, btemp1
    rlcf16 btemp0, btemp1
    rlcf16 btemp0, btemp1
clz16_Continue2:
    MOVLW 0x40
    CPFSLT btemp1 ;c = (x < 0x4000) << 2
    GOTO clz16_Continue3
    MOVLW 0x02
    ADDWF btemp2 ; r += c
    rlcf16 btemp0, btemp1 ; x << c
    rlcf16 btemp0, btemp1
clz16_Continue3:
    MOVLW 0x80
    CPFSLT btemp1 ;c = (x < 0x8000) << 2
    GOTO clz16_Continue4
    MOVLW 0x01
    ADDWF btemp2 ; r += c
    rlcf16 btemp0, btemp1 ; x << c
clz16_Continue4:
    RETURN

sqrt16_impl:
    xl_sqrt16 EQU btemp4
    xh_sqrt16 EQU btemp5
    yl_sqrt16 EQU btemp6
    yh_sqrt16 EQU btemp7

    CLRF yl_sqrt16 ; y
    MOVLW 0x01
    MOVWF yh_sqrt16
    ; if (x <= 1)
    
    if_bigger16 xl_sqrt16, xh_sqrt16, yh_sqrt16, yl_sqrt16, if_label_sqrt16_1, else_label_sqrt16_1, middle_label_sqrt16_1
    GOTO sqrt16_check_done
    else_ else_label_sqrt16_1, end_if_label_sqrt16_1
    GOTO sqrt16_x_lower_1
    end_if end_if_label_sqrt16_1

sqrt16_check_done:
    shift_sqrt16 EQU btemp15
    ; shift = (16 - 1 - clz16(x)) & ~1;
    clz16 shift_sqrt16, xl_sqrt16, xh_sqrt16
    MOVLW 0x0F
    SUBWF shift_sqrt16, 1
    NEGF shift_sqrt16, 1
    MOVLW 0xFE
    ANDWF shift_sqrt16, 1

    ml_sqrt16 EQU btemp8
    mh_sqrt16 EQU btemp9
    shift_left16 ml_sqrt16, mh_sqrt16, yh_sqrt16, yl_sqrt16, shift_sqrt16 ;m = 1 << shift
    
    CLRF yl_sqrt16
    CLRF yh_sqrt16
    
sqrt16_loop:
    ; while (m)
    if_equ_zero_16 ml_sqrt16, mh_sqrt16, if_label_sqrt16_2, else_label_sqrt16_2
    GOTO sqrt16_end
    else_ else_label_sqrt16_2, end_if_label_sqrt16_2
    end_if end_if_label_sqrt16_2
    
    bl_sqrt16 EQU btemp10
    bh_sqrt16 EQU btemp11
    ; b = y + m
    add16 bl_sqrt16, bh_sqrt16, yl_sqrt16, yh_sqrt16, ml_sqrt16, mh_sqrt16
    ; y >>= 1
    BCF STATUS, 0
    rrcf16 yl_sqrt16, yh_sqrt16

    ; if (x >= b)
    if_lower16 xl_sqrt16, xh_sqrt16, bl_sqrt16, bh_sqrt16, if_label_sqrt16_3, else_label_sqrt16_3, middle_label_sqrt16_3
    GOTO sqrt16_continue
    else_ else_label_sqrt16_3, end_if_label_sqrt16_3
    ; x -= b
    sub16 xl_sqrt16, xh_sqrt16, xl_sqrt16, xh_sqrt16, bl_sqrt16, bh_sqrt16
    ; y += m
    add16 yl_sqrt16, yh_sqrt16, yl_sqrt16, yh_sqrt16, ml_sqrt16, mh_sqrt16
    end_if end_if_label_sqrt16_3

sqrt16_continue:
    ; m >>= 2
    BCF STATUS, 0
    rrcf16 ml_sqrt16, mh_sqrt16
    BCF STATUS, 0
    rrcf16 ml_sqrt16, mh_sqrt16
    GOTO sqrt16_loop

sqrt16_end:
    RETURN
sqrt16_x_lower_1:
    MOVFF xl_sqrt16, yl_sqrt16
    RETURN

meow:
    end


