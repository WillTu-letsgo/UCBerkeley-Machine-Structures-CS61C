.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
#   d = matmul(m0, m1)
# Arguments:
#   a0 (int*)  is the pointer to the start of m0
#   a1 (int)   is the # of rows (height) of m0
#   a2 (int)   is the # of columns (width) of m0
#   a3 (int*)  is the pointer to the start of m1
#   a4 (int)   is the # of rows (height) of m1
#   a5 (int)   is the # of columns (width) of m1
#   a6 (int*)  is the pointer to the the start of d
# Returns:
#   None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 38
# =======================================================
matmul:

    # Error checks
    addi t0,x0,1
    blt a1,t0,error
    blt a2,t0,error
    blt a4,t0,error
    blt a5,t0,error
    bne a2,a4,error
    
    addi sp,sp,-4
    sw ra 0(sp)
    # Prologue
    mv t0,a0
    mv t1,a1
    mv t2,a2
    mv t3,a3
    mv t4,a4
    mv t5,a5

outer_loop_start:
    mv a0,t0
    mv a1,t3
    mv a2,t2
    li a3,1
    
    addi sp,sp,-20
    sw t0,0(sp)
    sw t1,4(sp)
    sw t2,8(sp)
    sw t3,12(sp)
    sw t5,16(sp)
    
inner_loop_start:
    mv a0,t0
    mv a1,t3
    mv a2,t2
    li a3,1
    lw a4 16(sp)
    
    addi sp,sp,-24
    sw t0,0(sp)
    sw t1,4(sp)
    sw t2,8(sp)
    sw t3,12(sp)
    sw t5,16(sp)
    sw a6,20(sp)
    jal ra dot
    j inner_loop_end
    
inner_loop_end:
    lw a6,20(sp)
    lw t5,16(sp)
    lw t3,12(sp)
    lw t2,8(sp)
    lw t1,4(sp)
    lw t0,0(sp)
    addi sp,sp,24
    addi t3,t3,4
    addi t5,t5,-1
    sw a0,0(a6)
    addi a6,a6,4
    bne t5,x0,inner_loop_start
    j outer_loop_end

outer_loop_end:
    lw t0,0(sp)
    lw t1,4(sp)
    lw t2,8(sp)
    addi t1,t1,-1
    addi t3,x0,4
    mul t3,t3,t2
    add t0,t0,t3
    lw t3,12(sp)
    lw t5,16(sp)
    addi sp,sp,20
    bne t1,x0,outer_loop_start

    # Epilogue

    lw ra 0(sp)
    addi sp,sp,4
    jr ra

error:
    addi a0,x0,38
    j exit
    
