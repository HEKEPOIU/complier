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
# 4 + 6
    movq $4 , %rdi
    addq $6, %rdi
    call printint
# 2 * 21
    movq $21 , %rax
    movq $2, %rbx
    mulq %rbx
    movq %rax, %rdi
    call printint
# 4 + 7 / 2
    movq $7, %rax
    movq $2, %rbx
    divq %rbx
    movq %rax, %rdi
    addq $4, %rdi
    call printint
# 3 - 6 * (10 / 5)
    movq $10, %rax
    movq $5, %rbx
    divq %rbx ;# 10/5
    movq $6, %rbx 
    mulq %rbx ;#*6
    movq $3, %rbx 
    subq %rax, %rbx
    movq %rbx, %rdi
    call printint


    mov $0, %rax # exit code
    leave
    ret

