.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fwrite error or eof,
#     this function terminates the program with error code 30
# ==============================================================================
write_matrix:
    addi sp,sp,-4
    sw ra 0(sp)

    # Prologue
    mv t0,a0
    mv t1,a1
    mv t2,a2
    mv t3,a3
    
    addi sp,sp,-16
    sw t0,0(sp)
    sw t1,4(sp)
    sw t2,8(sp)
    sw t3,12(sp)
    addi a1,x0,1
    jal ra fopen
    lw t0,0(sp)
    lw t1,4(sp)
    lw t2,8(sp)
    lw t3,12(sp)
    addi sp,sp,16
    addi t0,x0,-1
    
    beq a0,t0,error27
    
    addi sp,sp,-16
    sw t2,0(sp)
    sw t3,4(sp)
    sw a0,8(sp)
    sw t1,12(sp)
    
    
    mv a1,sp
    addi a2,x0,2
    addi a3,x0,4
    jal ra fwrite
    add t5,a0,x0
    lw t1,12(sp)
    lw a0,8(sp)
    lw t3,4(sp)
    lw t2,0(sp)
    addi sp,sp,16
    addi t4,x0,2
    bne t4,t5,error30
    
    
    mv a1,t1
    mul t4,t2,t3
    mv a2,t4
    addi a3,x0,4
    addi sp,sp,-8
    sw a2,0(sp)
    sw a0,4(sp)
    jal ra fwrite
    lw a2,0(sp)
    add t0,x0,a0
    lw a0,4(sp)
    addi sp,sp,8
    
    bne a2,t0,error30
    
    jal ra fclose
    addi t0,x0,-1
    beq a0,t0,error28
    
    # Epilogue
    lw ra 0(sp)
    addi sp,sp,4

    jr ra
    
error27:
    addi a0,x0,27
    j exit
    
error28:
    addi a0,x0,28
    j exit
    
error30:
    addi a0,x0,30
    j exit
