addi t0 x0 -1
addi t1 x0 -1
beq t0 t1 label1
label2: addi t0 t0 -2
label1: addi t0 t0 1
bne t0 t1 label2
jal ra end
end: