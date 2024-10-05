.text
.globl main


message:
    .string "sqrt(%2d) = %2d\n"

isqrt:
    pushq %rbp
    movq %rsp, %rbp

    subq $16, %rsp
    movl %edi, -4(%rbp) # n
    movl $0, -8(%rbp) # c
    movl $1, -12(%rbp) # s
    movl -12(%rbp), %r8d
    jmp checksqrt

calsqrt:
    addl $1, -8(%rbp)
    movl -8(%rbp), %edi
    leal 1(%r8d,%edi, 2), %r8d # s = 2 c + s + 1
    movl %r8d, -12(%rbp)

checksqrt:
    cmpl -4(%rbp), %r8d # s<=n
    jle calsqrt
    movl -8(%rbp), %eax
    leave
    ret


main:
    pushq %rbp
    movq %rsp, %rbp

    subq $16, %rsp
    movl $0, -4(%rbp) #set n
    jmp compare

printloop:
    movl -4(%rbp), %edi
    call isqrt
    movl %eax, %edx #take isqrt result
    movl -4(%rbp), %esi # take n
    leaq message(%rip), %rdi # take message
    movq $0, %rax # reset
    call printf
    addl $1, -4(%rbp)

compare:
    cmpl $20, -4(%rbp) # n <= 20
    jle printloop
    
    mov $0, %rax # exit code
    leave
    ret
