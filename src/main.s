@ Helper constants for setting 001 (OUTPUT) in GPSEL registers
.equ GPSEL_OUPTUT_BANK_0, 0x1
.equ GPSEL_OUPTUT_BANK_1, 0x8
.equ GPSEL_OUPTUT_BANK_2, 0x40
.equ GPSEL_OUPTUT_BANK_3, 0x200
.equ GPSEL_OUPTUT_BANK_4, 0x1000
.equ GPSEL_OUPTUT_BANK_5, 0x8000
.equ GPSEL_OUPTUT_BANK_6, 0x40000
.equ GPSEL_OUPTUT_BANK_7, 0x200000
.equ GPSEL_OUPTUT_BANK_8, 0x1000000
.equ GPSEL_OUPTUT_BANK_9, 0x8000000

@ Helper constants for setting the GPIO pin to HIGH
.equ GPSET0_PIN_0, 0x1
.equ GPSET0_PIN_1, 0x2
.equ GPSET0_PIN_2, 0x4
.equ GPSET0_PIN_3, 0x8
.equ GPSET0_PIN_4, 0x10
.equ GPSET0_PIN_5, 0x20
.equ GPSET0_PIN_6, 0x40
.equ GPSET0_PIN_7, 0x80
.equ GPSET0_PIN_8, 0x100
.equ GPSET0_PIN_9, 0x200
.equ GPSET0_PIN_10, 0x400
.equ GPSET0_PIN_11, 0x800
.equ GPSET0_PIN_12, 0x1000
.equ GPSET0_PIN_13, 0x2000
.equ GPSET0_PIN_14, 0x4000
.equ GPSET0_PIN_15, 0x8000
.equ GPSET0_PIN_16, 0x10000
.equ GPSET0_PIN_17, 0x20000
.equ GPSET0_PIN_18, 0x40000
.equ GPSET0_PIN_19, 0x80000
.equ GPSET0_PIN_20, 0x100000
.equ GPSET0_PIN_21, 0x200000
.equ GPSET0_PIN_22, 0x400000
.equ GPSET0_PIN_23, 0x800000
.equ GPSET0_PIN_24, 0x1000000
.equ GPSET0_PIN_25, 0x2000000
.equ GPSET0_PIN_26, 0x4000000
.equ GPSET0_PIN_27, 0x8000000
.equ GPSET0_PIN_28, 0x10000000
.equ GPSET0_PIN_29, 0x20000000
.equ GPSET0_PIN_30, 0x40000000
.equ GPSET0_PIN_31, 0x80000000

.equ GPIO_base, 0x3f200000

@ GPIO register offsets
.equ GPFSEL0, 0x0
.equ GPFSEL1, 0x4
.equ GPFSEL2, 0x8
.equ GPFSEL3, 0xC
.equ GPFSEL4, 0x10 
.equ GPFSEL5, 0x14

.equ GPSET0, 0x1C 
.equ GPSET1, 0x20

.equ GPCLR0, 0x28
.equ GPCLR1, 0x2C

.equ TIMER_base, 0x3f003000
.equ TIMER_CLO, 0x4

ldr r0,=GPIO_base
ldr r6,=TIMER_base

bl pin_init
bl blink_leds


@ Initialize yellow pin
pin_init:
	mov r1, #GPSEL_OUPTUT_BANK_4
	orr r1, #GPSEL_OUPTUT_BANK_5
	orr r1, #GPSEL_OUPTUT_BANK_6
	str r1, [r0, #GPFSEL0]
	BX lr

pin_yellow_off:
	mov r1, #GPSET0_PIN_4
	str	r1, [r0, #GPCLR0]
	BX lr

pin_yellow_on:
	mov r1, #GPSET0_PIN_4
	str	r1, [r0, #GPSET0]
	BX lr


pin_green_off:
	mov r1, #GPSET0_PIN_5
	str	r1, [r0, #GPCLR0]
	BX lr

pin_green_on:
	mov r1, #GPSET0_PIN_5
	str	r1, [r0, #GPSET0]
	BX lr


pin_red_off:
	mov r1, #GPSET0_PIN_6
	str	r1, [r0, #GPCLR0]
	BX lr

pin_red_on:
	mov r1, #GPSET0_PIN_6
	str	r1, [r0, #GPSET0]
	BX lr


blink_leds:
	blink_leds_loop:
		bl pin_yellow_on
		bl short_break
		bl pin_yellow_off
		bl short_break

		bl pin_green_on
		bl short_break
		bl pin_green_off
		bl short_break
		
		bl pin_red_on
		bl short_break
		bl pin_red_off
		bl long_break

		bl blink_leds_loop
	bx lr


@ Timer based pause
short_break:
	mov r8, #500
	mov r9, #1000
	mul r7, r8, r9 @ 500 * 1000 * r7 ~= 500ms
	ldr r10, [r6, #TIMER_CLO] @ START time

	short_break_wait:
		ldr r11, [r6, #TIMER_CLO] @ current time
		sub r11, r11, r10 @ current time - start time = elapsed time
		cmp r11, r7 @ current elapsed time == wait period?
		blt short_break_wait

	bx lr

long_break:
	mov r8, #1000
	mov r9, #1000
	mul r7, r8, r9 @ 500 * 1000 * r7 ~= 500ms
	ldr r10, [r6, #TIMER_CLO] @ START time

	long_break_wait:
		ldr r11, [r6, #TIMER_CLO] @ current time
		sub r11, r11, r10 @ current time - start time = elapsed time
		cmp r11, r7 @ current elapsed time == wait period?
		blt short_break_wait

	bx lr

