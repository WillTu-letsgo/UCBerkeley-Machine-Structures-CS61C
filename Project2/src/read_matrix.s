.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
#   - If malloc returns an error,
#     this function terminates the program with error code 26
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fread error or eof,
#     this function terminates the program with error code 29
# ==============================================================================
read_matrix:
    addi sp,sp,-4
    sw ra,0(sp)

    # Prologue
    mv t0,a0
    mv t1,a1
    mv t2,a2
    
    add a1,x0,x0
    addi sp,sp,-12
    sw t0,0(sp)
    sw t1,4(sp)
    sw t2,8(sp)
    jal ra fopen
    lw t0,0(sp)
    lw t1,4(sp)
    lw t2,8(sp)
    addi sp,sp,12
    
    addi t3,x0,-1
    beq a0,t3,error27
    
    mv a1,t1
    addi a2,x0,4
    addi sp,sp,-24
    sw a0,0(sp)
    sw a1,4(sp)
    sw a2,8(sp)
    sw t0,12(sp)
    sw t1,16(sp)
    sw t2,20(sp)
    jal ra fread 
    add t3,a0,x0
    lw a0,0(sp)
    lw a1,4(sp)
    lw a2,8(sp)
    lw t0,12(sp)
    lw t1,16(sp)
    lw t2,20(sp)
    addi sp,sp,24
    
    bne t3,a2,error29
    
    mv a1,t2
    addi a2,x0,4
    addi sp,sp,-24
    sw a0,0(sp)
    sw a1,4(sp)
    sw a2,8(sp)
    sw t0,12(sp)
    sw t1,16(sp)
    sw t2,20(sp)
    jal ra fread 
    add t3,a0,x0
    lw a0,0(sp)
    lw a1,4(sp)
    lw a2,8(sp)
    lw t0,12(sp)
    lw t1,16(sp)
    lw t2,20(sp)
    addi sp,sp,24
    
    bne t3,a2,error29
    
    lw t3,0(t1)
    lw t4,0(t2)
    addi sp,sp,-20
    sw a0,0(sp)
    sw t0,4(sp)
    sw t1,8(sp)
    sw t2,12(sp)
    mul a0,t3,t4    
    slli a0,a0,2
    sw a0,16(sp)
    jal ra,malloc
    add t3,x0,a0
    lw a0,0(sp)
    lw t0,4(sp)
    lw t1,8(sp)
    lw t2,12(sp)
    lw a2,16(sp)
    addi sp,sp,20
    
    beq t3,x0,error26
    
    mv a1,t3
    addi sp,sp,-24
    sw a0,0(sp)
    sw a1,4(sp)
    sw a2,8(sp)
    sw t0,12(sp)
    sw t1,16(sp)
    sw t2,20(sp)
    jal ra fread 
    add t3,a0,x0
    lw a0,0(sp)
    lw a1,4(sp)
    lw a2,8(sp)
    lw t0,12(sp)
    lw t1,16(sp)
    lw t2,20(sp)
    addi sp,sp,24
    
    bne t3,a2,error29
    
    addi sp,sp,-4
    sw a1,0(sp)
    jal ra,fclose
    lw a1,0(sp)
    addi sp,sp,4
    addi t0,x0,-1
    beq a0,t0,error28
    
    add a0,x0,a1
    
    # Epilogue
    lw ra,0(sp)
    addi sp,sp,4

    jr ra
    
error26:
    addi a0,x0,26
    j exit
    
error27:
    addi a0,x0,27
    j exit
    
error28:
    addi a0,x0,28
    j exit
    
error29:
    addi a0,x0,29
    j exit
