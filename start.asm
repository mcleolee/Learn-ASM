.global _start
_start:




reset:
    /* 设置为SVC MODE */
    mrs r0, cpsr        @ read CPSR and put to r0
    bic r0, r0, #0x1f   @ clear the bits to 0       @
    orr r0, r0, #0xd3   @ 置位: set the bits to 1   @1101 0011
    msr cpsr, r0        @ 将修改好的值写回到 CPSR 模式

    /* 设置异常向量表首地址 */
    ldr r0, =0x0
    mcr p15, 0, r0, c12, c0, 0      @协处理器 VBAR，不是 ARM 的指令

    /* INIT */


    /* 设置为USER MODE */
    mrs r0, cpsr        @ read CPSR and put to r0
    bic r0, r0, #0x1f   @ clear the bits to 0       @
    orr r0, r0, #0x10   @ 置位: set the bits to 1   @ 0001 0000
    msr cpsr, r0        @ 将修改好的值写回到 CPSR 模式

    BL _main
_main:
    MOV r1, #3
    MOV r2, #4
    BL  add_usr
    MOV r3, #1

loop:
    B loop      @ 写一个死循环 防止程序跑飞

add_usr:
    stmfd sp!, {lr}        @ backup
