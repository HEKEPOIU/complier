.text
.globl main

main:
    pushq %rbp
    movq %rsp, %rbp
    movq $message, %rdi
    call puts
    movq $0, %rax
    popq %rbp
    ret

.data
message:
    .string "hello, world"
