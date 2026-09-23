addi s0 x0 10
addi t0 x0 1
loop: addi t0 t0 1
beq t0 s0 lop
jal ra loop
add t1 ra x0
lop: jalr ra t1 end
end:
