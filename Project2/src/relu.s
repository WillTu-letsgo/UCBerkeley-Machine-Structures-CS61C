.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
#   a0 (int*) is the pointer to the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   None
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# ==============================================================================
relu:
    # Prologue
    addi t0,x0,1
    add t1,x0,x0
    blt a1,t0,error
    
loop_start:
    lw t1,0(a0)
    blt t1,x0,loop_continue
    addi a1,a1,-1
    addi a0,a0,4
    blt x0,a1,loop_start
    beq a1,x0,loop_end
 
loop_continue:
    sw x0,0(a0)
    addi a1,a1,-1
    addi a0,a0,4
    blt x0,a1,loop_start
    beq a1,x0,loop_end

loop_end:

    # Epilogue


    jr ra
    
error:
    li a0 36
    j exit
