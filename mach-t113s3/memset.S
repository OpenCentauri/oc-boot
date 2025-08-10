.global memset
memset:
    mov r3, r0
.L1:
    subs r2, r2, #1
    strb r1, [r3], #1
    bne .L1
    bx lr
