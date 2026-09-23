.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int arrays
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the number of elements to use
#   a3 (int)  is the stride of arr0
#   a4 (int)  is the stride of arr1
# Returns:
#   a0 (int)  is the dot product of arr0 and arr1
# Exceptions:
#   - If the number of elements to use is less than 1,
#     this function terminates the program with error code 36
#   - If the stride of either array is less than 1,
#     this function terminates the program with error code 37
# =======================================================
dot:

    # Prologue
    add t0,x0,x0
    add t1,x0,x0
    add t2,x0,x0
    add t3,x0,x0
    add t4,x0,x0
    addi t5,x0,1
    addi t6,x0,4
    blt a2,t5,error1
    blt a3,t5,error2
    blt a4,t5,error2
    add t5,x0,x0
    
loop_start:
    lw t0,0(a0)
    lw t1,0(a1)
    mul t2,t1,t0
    add t5,t2,t5
    addi a2,a2,-1
    beq a2,x0,loop_end
    mul t3,a3,t6
    mul t4,a4,t6
    add a0,a0,t3
    add a1,a1,t4
    blt x0,a2,loop_start
    
loop_end:
    add a0,t5,x0

    # Epilogue
    jr ra

error1:
    li a0,36
    j exit

error2:
    li a0,37
    j exit

