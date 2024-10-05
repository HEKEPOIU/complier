.text
.globl main

printint:
    pushq %rbp
    movq %rsp, %rbp
    movq %rdi, %rsi
    leaq message(%rip), %rdi #Need use leaq to calculate relative address reference so that support PIE.
    movq $0, %rax
    call printf
    leave
    ret


message:
    .string "%d\n"

main:
    pushq %rbp
    movq %rsp, %rbp

    movq x(%rip), %rdi # x to rax
    movq %rdi, %rax
    mulq %rax ;# x * x
    movq %rax, y(%rip) # y = x * x

    addq y(%rip), %rdi
    call printint


    mov $0, %rax # exit code
    leave
    ret


    
.data
x:
    .long 2
y:
    .long 0
