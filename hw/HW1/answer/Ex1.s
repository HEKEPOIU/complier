.text
.globl main

message:
    .string "n=%d\n"
main:
    pushq %rbp
    movq %rsp, %rbp
    leaq message(%rip), %rdi #Need use leaq to calculate relative address reference so that support PIE.
    movq $42, %rsi 
    movq $0, %rax
    call printf
    mov $0, %rax # exit code

    leave
    ret

