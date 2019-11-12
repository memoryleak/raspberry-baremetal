.equ GPIO_BASE, 0x3f200000

.text
.global gpio_fsel 
.type   gpio_fsel, %function

@ r0: GPIO pin number
@ r1: GPIO fsel bit
gpio_fsel:
    
    MOV r5, #10
    
    UDIV r6, r0, r5 @ r6: contains quotient of PIN_NUM dividid by 10
    MSUB r7, r6, r5, r0 @ r7: get the remainder of the division (PIN_NUM % 10)
    
    MOV r8, #0x4
    MUL r8, r6 @ Mulitply (PIN_NUM / 10) with 0x4 to get the register offset
    LDR r4, [r8, #GPIO_BASE] @ Load calculated FSEL register 

    MOV r5, #0b111
    LSL r5, r7
    BIC r4, r4, r5 @ Clear bits for this pin

    MOV r5, r1
    LSL r5, r7
    ORR r4, r5 @ Set provided function bits (INPUT/OUTPUT/Other)
    
    STR r4, [] 
