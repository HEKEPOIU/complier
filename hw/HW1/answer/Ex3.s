.text
.globl main

printbool:
    pushq %rbp
    movq %rsp, %rbp
    
    testq %rdi, %rdi # test is %rdi zero
    jz printzero
    
    leaq true_message(%rip), %rdi 
    movq $0, %rax
    call printf

    leave
    ret

printzero:

    leaq false_message(%rip), %rdi 
    movq $0, %rax
    call printf
    leave
    ret

printint:
    pushq %rbp
    movq %rsp, %rbp
    movq %rdi, %rsi
    leaq message(%rip), %rdi #Need use leaq to calculate relative address reference so that support PIE.
    movq $0, %rax
    call printf
    leave
    ret


true_message:
    .string "true\n"
false_message:
    .string "false\n"

message:
    .string "%d\n"

main:
    pushq %rbp
    movq %rsp, %rbp

# true && false
    movq $1, %rdi
    andq $0, %rdi
    call printbool
# if 3 != 4 then 10 * 2 else 14
    movq $3, %rdi
    cmpq $4, %rdi
    jnz print_20
    movq $14, %rdi
    call printint
    jmp q_3    

print_20:
    movq $20, %rdi
    call printint

q_3:
# 2 = 3 || 4 <= 2 * 3
# false || true    
    movq $2, %rdi
    cmpq $3, %rdi
    setz %al
    movzbq %al, %rdi

    movq $3, %rsi
    movq $2, %rax
    mulq %rsi

    movq $4, %rsi
    cmpq %rsi, %rax
    setge %cl
    movzbq %cl, %rsi

    orq %rsi, %rdi
    call printbool


    mov $0, %rax # exit code
    leave
    ret


