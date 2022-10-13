.global _start
_start:

B   reset
ldr pc, _undefined_instruction
ldr pc, _software_interrupt
ldr pc, _prefetch_abort
ldr pc, _data_abort
ldr pc, _not_used
ldr pc, _irq
ldr pc, _fiq

_undefined_instruction: .word   _undefined_instruction  
_software_interrupt:    .word   swi_handler
_prefetch_abort:        .word   _prefetch_abort
_data_abort:            .word   _data_abort
_not_used:              .word   _not_used
_irq:                   .word   _irq
_fiq:                   .word   _fiq




reset:
    /* 设置为SVC MODE */
    mrs r0, cpsr        @ read CPSR and put to r0
    bic r0, r0, #0x1f   @ clear the bits to 0
    orr r0, r0, #0xd3   @ 置位: set the bits to 1   @1101 0011
    msr cpsr, r0        @ 将修改好的值写回到 CPSR 模式

    /* 设置异常向量表首地址 */
    ldr r0, =0x0
    mcr p15, 0, r0, c12, c0, 0      @协处理器 VBAR, 不是 ARM 的指令

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
    NOP

loop:
    B loop      @ 写一个死循环 防止程序跑飞

add_usr:
    STMFD   sp!, {lr}               @ backup, 将 * 压栈
    SWI     0                       @ 产生软中断
    MOV     r3, #2
    LDMFD sp!, {pc}                 @ 出栈备份的数据 将 lr 直接出栈给pc

swi_handler:
    STMFD   sp!, {lr}               @ backup, 将 * 压栈
    /* 判断中断类型 */
    BL      add_sys
    LDMFD sp!, {pc}^                @ 出栈备份的数据 将 lr 直接出栈给pc
                                    @ 

add_sys:
    STMFD sp!, {lr}                 @ backup, 将 * 压栈
    ADD r0, r1, r2
    LDMFD sp!, {pc}