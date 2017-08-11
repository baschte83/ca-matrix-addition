 @ matadd file for lab 3 "Performance Measurement Optimization" wih matrix addition
    @ by students Ehsan Moslehy and Sebastian Baumann

    /* This function has 5 parameters, and the declaration in the
       C-language would look like:

       void matadd (int **C, int **A, int **B, int height, int width)

       C, A, B, and height will be passed in r0-r3, respectively, and
       width will be passed on the stack.

       You need to write a function that computes the sum C = A + B.

       A, B, and C are arrays of arrays (matrices), so for all elements,
       C[i][j] = A[i][j] + B[i][j]

       You should start with two for-loops that iterate over the height and
       width of the matrices, load each element from A and B, compute the
       sum, then store the result to the correct element of C. 

       This function will be called multiple times by the driver, 
       so don't modify matrices A or B in your implementation.

       As usual, your function must obey correct ARM register usage
       and calling conventions. */

	.arch armv7-a	@ maybe we have to change it to armv6
	.text
	.align	2
	.global	matadd
	.syntax unified
	.arm

	@ r0: adress to matrix C
	@ r1: adress to matrix A
	@ r2: adress to matrix B
	@ r3: height of all matrizes as an integer
	@ r4: value from matrix
	@ r5: result of sum
	@ r6: offset rows
	@ r7: offset columns
	@ sp: (from Stack): number of columns of all matrizes as an integer

matadd:
	PUSH	{r4,r5,r6,r7,r8,r9,r10,lr}		@ save callee-save registers to stack

	LSL	r6, r3, #2			@ shift height by 2 so it is multiplied by 4
	SUB	r6, r6, #4
@	MOV	r6, r3				@ initialize row-offset with 0
	LDR	r4, [sp, #32]			@ load width of matrizes in r4
@	STR	r3, [sp,#-4]
	LSL	r4, r4, #2			@ shift width by 2 so it is multiplied by 4 
	STR	r4, [sp, #32]			@ stores height to stack
@	MOV	r3, r4				@ loads width in r3
@	SUB	sp, sp, #4			@ make place for width on stack
@	STR	r4, [sp]			@ stores width on stack

loop_rows:					@ loop to iterate through all rows of a matrix

	LDR	r7, [sp, #32]			@ initialize columns-offset with width
	LDR	r8, [r0, r6]			@ get pointer to cell C[i][j]
	LDR	r9, [r1, r6]			@ get pointer to row i in matrix A
	LDR	r3, [r2, r6]			@ get pointer to row i in matrix B
	SUB	r7, r7, #4	

loop_columns:					@ loop to iterate through all columns of a matrix
	
	LDR	r4, [r9, r7]			@ get value A[i][j]

	LDR	r5, [r3, r7]			@ get value B[i][j]
	ADD	r5, r5, r4			@ add value B[i][j] to sum

	STR	r5, [r8, r7]			@ store sum in cell C[i][j]

	SUBS	r7, r7, #4			@ compare columns-offset with iterated columns
	BGE	loop_columns			@ loops through all columns if column-counter != number of columns

@	LDR	r4, [sp, #32]			@ get number of rows of matrizes (height)
@	ADD	r6, r6, #4			@ increase row-offset by 4
	SUBS	r6, r6, #4				@ compare row-offset and number of rows
	BGE	loop_rows			@ loops through all rows if row-counter != number of rows

	
	POP	{r4,r5,r6,r7,r8,r9,r10,lr}		@ restore callee-save registers from stack
	BX	lr				@ jump back to caller
