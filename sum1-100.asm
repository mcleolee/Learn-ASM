start:
    mov     r1, #0
    add     r1, #1
    CMP     r1,	100
    bgt     end
    ble     start
end:
    nop
    nop