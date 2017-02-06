@ ARM Assembly - Project 1
@ Gamage C.T.N - E/13/107
@ Date         - 24/07/2016

	.text	@ instruction memory
	
	.global main
main:
	
	@ stack handling
	@ push (store) lr to the stack
	sub	sp, sp, #4
	str	lr, [sp, #0]

	@allocate stack for input
	sub	sp, sp, #16
	
	ldr	r0, =formatp1
	bl 	printf

	@scanf to get an integer
	ldr	r0, =formats
	mov	r1, sp	
	bl	scanf	@scanf
	
	@saving the K1 in 32 bit registers
	ldr	r4,[sp,#0]
	ldr	r5,[sp,#4]

	@scanf to get an integer
	ldr	r0, =formats
	mov	r1,sp
	bl	scanf	@scanf
	
	@saving the K2 in 32 bit registers
	ldr	r6,[sp,#0]
	ldr	r7,[sp,#4]
	
	ldr	r0, =formatp2
	bl 	printf

	@scanf to get an integer
	ldr	r0, =formats
	mov	r1,sp
	bl	scanf	@scanf
	
	@saving the PT1 in 32 bit registers
	ldr	r8,[sp,#0]
	ldr	r9,[sp,#4]
		
	@scanf to get an integer
	ldr	r0, =formats
	mov	r1,sp
	bl	scanf	@scanf
	
	@saving the PT2 in 32 bit registers
	ldr	r10,[sp,#0]
	ldr	r11,[sp,#4]
	
	@Initial R function call
	mov	r0,#1
	bl	roundAll
	mov	r12,#0

loop:	
	@r12 is the counter and checking for 31 iterations
	cmp	r12,#31
	bge	exit
	str	r12, [sp, #12]
	
	@two R funtion calls inside the loop
	mov	r0,#2
	bl	roundAll
	mov	r0,#1
	bl	roundAll
	
	@incrementing the counter
	ldr	r12, [sp, #12]
	add	r12,#1
	b	loop


exit:	
	@printing the final cipher text
	mov r1,r8
	mov r2,r9
	ldr	r0, =formatp3
	bl 	printf
	
	mov r1,r10
	mov r2,r11
	ldr	r0, =formatp4
	bl 	printf
	
	@release stack
	add	sp, sp, #16

  	@stack handling 
	ldr	lr, [sp, #0]
	add	sp, sp, #4
	mov	pc, lr		

@============================================

roundRight:

	@the ROR function
	@stack handling and backing up the stored values
	sub	sp, sp, #32
	str	lr, [sp, #0]
	str	r4, [sp, #4]
	str	r5, [sp, #8]
	str	r6, [sp, #12]
	str	r7, [sp, #16]
	str	r8, [sp, #20]
	str	r9, [sp, #24]
	str	r10, [sp, #28]

	mov	r9,r0
	mov	r10,r1

	@right----------------------------- >>	
	mov	r3,#8
	mov	r4,#32

	lsr	r5,r0,r3
	lsr	r6,r1,r3

	lsl	r0,r6,r3
	sub	r1,r1,r0
	
	sub	r3,r4,r3
	lsl	r0,r1,r3
	add	r5,r5,r0
	@left----------------------------- <<
	
	mov	r7,r5
	mov	r8,r6	
	
	lsl	r6,r9,#24
	mov 	r5,#0

	@orr----------------------------- |
	orr r1,r6,r8
	orr r0,r5,r7

 	@stack handling and restoring the stored values
	ldr	lr, [sp, #0]
	ldr	r4, [sp, #4]
	ldr	r5, [sp, #8]
	ldr	r6, [sp, #12]
	ldr	r7, [sp, #16]
	ldr	r8, [sp, #20]
	ldr	r9, [sp, #24]
	ldr	r10, [sp, #28]

	add	sp, sp, #32
	mov	pc, lr

	
	

@============================================

roundLeft:

	@the ROL function
	@stack handling and backing up the stored values
	sub	sp, sp, #32
	str	lr, [sp, #0]
	str	r4, [sp, #4]
	str	r5, [sp, #8]
	str	r6, [sp, #12]
	str	r7, [sp, #16]
	str	r8, [sp, #20]
	str	r9, [sp, #24]
	str	r10, [sp, #28]
	
	mov	r9,r0
	mov	r10,r1

	@left----------------------------- <<	

	mov	r3,#3
	mov	r4,#32
	
	lsl	r5,r0,r3
	lsl	r6,r1,r3

	lsr	r1,r5,r3
	sub	r0,r0,r1
	
	sub	r3,r4,r3
	lsr	r0,r0,r3
	add	r6,r6,r0

	@right----------------------------- >>	

	mov	r7,r5
	mov	r8,r6	

	lsr	r5,r10,#29
	mov 	r6,#0

	@orr----------------------------- |
	
	orr r1,r6,r8
	orr r0,r5,r7

	@stack handling and restoring the stored values
	ldr	lr, [sp, #0]
	ldr	r4, [sp, #4]
	ldr	r5, [sp, #8]
	ldr	r6, [sp, #12]
	ldr	r7, [sp, #16]
	ldr	r8, [sp, #20]
	ldr	r9, [sp, #24]
	ldr	r10, [sp, #28]

	add	sp, sp, #32
	mov	pc, lr

@============================================

roundAll:

	@the R function
	@stack handling

	sub	sp, sp, #4
	str	lr, [sp, #0]

	@checking whether the call one or two
	cmp	r0,#1
	beq	callOne
	cmp	r0,#2
	beq	callTwo
	b	end
	
callOne:

	@roundRight

	mov	r0,r8
	mov	r1,r9
	bl	roundRight
	mov	r8,r0
	mov	r9,r1

	@adding

	adds	r0,r8,r10
	adc	r1,r9,r11
	mov	r8,r0
	mov	r9,r1
	
	@xor

	eor	r0,r8,r6
	eor	r1,r9,r7
	mov	r8,r0
	mov	r9,r1

	@roundLeft

	mov	r0,r10
	mov	r1,r11
	bl	roundLeft
	mov	r10,r0
	mov	r11,r1
	
	@xor

	eor	r0,r8,r10
	eor	r1,r9,r11
	mov	r10,r0
	mov	r11,r1
	
	b	end

callTwo:

	@roundRight

	mov	r0,r4
	mov	r1,r5
	bl	roundRight
	mov	r4,r0
	mov	r5,r1

	@adding

	adds	r0,r4,r6
	adc	r1,r5,r7
	mov	r4,r0
	mov	r5,r1
	
	@xor

	eor	r0,r4,r12
	eor	r1,r5,#0
	mov	r4,r0
	mov	r5,r1

	@roundLeft

	mov	r0,r6
	mov	r1,r7
	bl	roundLeft
	mov	r6,r0
	mov	r7,r1
	
	@xor

	eor	r0,r4,r6
	eor	r1,r5,r7
	mov	r6,r0
	mov	r7,r1

	b	end

end:

	@stack handling
	ldr	lr, [sp, #0]
	add	sp, sp, #4
	mov	pc, lr

	.data	@ data memory
formatp1: .asciz "Enter the key:\n"
formatp2: .asciz "Enter the plain text:\n"
formatp3: .asciz "Cipher text is:\n%llx "
formatp4: .asciz "%llx\n"
formats: .asciz "%llx"
