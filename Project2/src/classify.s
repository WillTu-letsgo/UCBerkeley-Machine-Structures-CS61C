.globl classify

.text
# =====================================
# COMMAND LINE ARGUMENTS
# =====================================
# Args:
#   a0 (int)        argc
#   a1 (char**)     argv
#   a1[1] (char*)   pointer to the filepath string of m0
#   a1[2] (char*)   pointer to the filepath string of m1
#   a1[3] (char*)   pointer to the filepath string of input matrix
#   a1[4] (char*)   pointer to the filepath string of output file
#   a2 (int)        silent mode, if this is 1, you should not print
#                   anything. Otherwise, you should print the
#                   classification and a newline.
# Returns:
#   a0 (int)        Classification
# Exceptions:
#   - If there are an incorrect number of command line args,
#     this function terminates the program with exit code 31
#   - If malloc fails, this function terminates the program with exit code 26
#
# Usage:
#   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
classify:
    li t0,5
    bne a0,t0,error31
    addi sp,sp,-36
    sw ra,0(sp)
    sw s0,4(sp)
    sw s1,8(sp)
    sw s2,12(sp)
    sw s3,16(sp)
    sw s4,20(sp)
    sw s5,24(sp)
    sw s6,28(sp)
    sw s7,32(sp)
    
    mv s0,a2
    lw s1,4(a1)
    lw s2,8(a1)
    lw s3,12(a1)
    lw s4,16(a1)
    
    # Read pretrained m0
    mv a0,s1
    addi sp,sp,-12
    mv s5,sp
    addi a1,s5,8
    addi a2,s5,4
    jal ra read_matrix
    sw a0,0(s5)
    
    # Read pretrained m1
    mv a0,s2
    addi sp,sp,-12
    mv s6,sp
    addi a1,s6,8
    addi a2,s6,4
    jal ra read_matrix
    sw a0,0(s6)

    # Read input matrix
    mv a0,s3
    addi sp,sp,-12
    mv s7,sp
    addi a1,s7,8
    addi a2,s7,4
    jal ra read_matrix
    sw a0,0(s7)

    # Compute h = matmul(m0, input)
    lw t0,8(s5)
    lw t1,4(s7)
    mul a0,t0,t1
    slli a0,a0,2
    jal ra malloc
    beq a0,x0,error26
    mv a6,a0
    lw a0,0(s5)
    lw a1,8(s5)
    lw a2,4(s5)
    lw a3,0(s7)
    lw a4,8(s7)
    lw a5,4(s7)
    mv s1,a6
    jal ra matmul
        
    # Compute h = relu(h)
    mv a0,s1
    lw t0,8(s5)
    lw t1,4(s7)
    mul a1,t0,t1
    jal ra relu

    # Compute o = matmul(m1, h)
    lw t0,8(s6)
    lw t1,4(s7)
    mul a0,t0,t1
    slli a0,a0,2
    jal ra malloc
    beq a0,x0,error26
    mv a3,s1
    mv a6,a0
    mv s2,a6
    lw a0,0(s6)
    lw a1,8(s6)
    lw a2,4(s6)
    lw a4,8(s5)
    lw a5,4(s7)
    jal ra matmul
    
    # Write output matrix o
    mv a0,s4
    mv a1,s2
    lw a2,8(s6)
    lw a3,4(s7)
    addi sp,sp,-4
    sw a1,0(sp)
    jal ra write_matrix
    lw a1,0(sp)
    addi sp,sp,4
    

    # Compute and return argmax(o)
    mv a0,s2
    lw t0,8(s6)
    lw t1,4(s7)
    mul a1,t0,t1
    jal ra argmax
    mv s3,a0
    mv a2,s0
    beq a2,x0,print
    bne a2,x0,done

    # If enabled, print argmax(o) and newline
print:
    jal ra print_int
    li a0 '\n'
    jal ra print_char

done:
    addi sp,sp,-4
    sw s3,0(sp)
    lw a0 0(s5)
    jal ra free
    lw a0 0(s6)
    jal ra free
    lw a0 0(s7)
    jal ra free
    mv a0,s1
    jal ra free
    mv a0,s2
    jal ra free
    lw a0,0(sp)
    addi sp,sp,4
    addi sp,sp,36
    
    
    
    lw ra,0(sp)
    lw s0,4(sp)
    lw s1,8(sp)
    lw s2,12(sp)
    lw s3,16(sp)
    lw s4,20(sp)
    lw s5,24(sp)
    lw s6,28(sp)
    lw s7,32(sp)
    addi sp,sp,36

    jr ra
    
 error26:
    addi a0,x0,26
    j exit
    
error31:
    addi a0,x0,31
    j exit
