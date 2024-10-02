# Function Call pass arguments<- %rdi, %rsi, %rdx, %rcx, %r8, %r9, and rest passed by stack.
# callee-saved <- %rbx, %rbp, %r12, %r13, %14 and %r15
# And rest are caller-saved.
.text
.globl main

t:
        pushq   %rbp
        movq    %rsp, %rbp
        subq    $32, %rsp
        movl    %edi, -20(%rbp) #a
        movl    %esi, -24(%rbp) #b
        movl    %edx, -28(%rbp) #c
        movl    $1, -4(%rbp) # init f
        cmpl    $0, -20(%rbp) # cmp a 0
        je      .L2
        movl    -24(%rbp), %eax #take b
        notl    %eax ;# not b
        andl    -20(%rbp), %eax # and a (not b)
        movl    -28(%rbp), %edx # take c
        notl    %edx ;# not c
        andl    %edx, %eax # and (a (not b)) (not c)
        movl    %eax, -8(%rbp) #e = a & ~b & ~c
        movl    $0, -4(%rbp) # f = 0
        jmp     .L3
.L4:
        movl    -28(%rbp), %edx # take c
        movl    -12(%rbp), %eax # take d
        addl    %edx, %eax # c+d
        movl    %eax, %edx
        shrl    $31, %edx
        addl    %edx, %eax
        sarl    %eax
        movl    %eax, %esi
        movl    -24(%rbp), %edx # take b
        movl    -12(%rbp), %eax # take d
        addl    %edx, %eax # b + d
        leal    (%rax,%rax), %ecx # 2(b+d)
        movl    -20(%rbp), %eax # take a
        subl    -12(%rbp), %eax # a-d
        movl    %esi, %edx #set next c
        movl    %ecx, %esi #set next b
        movl    %eax, %edi #set next a
        call    t
        addl    %eax, -4(%rbp) # f+t return val
        movl    -12(%rbp), %eax # take d
        subl    %eax, -8(%rbp) # e - d
.L3:
        movl    -8(%rbp), %eax #take e
        negl    %eax ;#not e
        andl    -8(%rbp), %eax # and (not e) e
        movl    %eax, -12(%rbp) # d = e & ~e
        cmpl    $0, -12(%rbp) # d == 0
        setne   %al ;# if d == 0 then 0 else 1
        testb   %al, %al #if al = 1 then clear ZF else Set ZF
        jne     .L4 ;# jump if ZF not set
.L2:
        movl    -4(%rbp), %eax
        leave
        ret
.LC0:
        .string "%d"
.LC1:
        .string "q(%d) = %d\n"
main:
        pushq   %rbp
        movq    %rsp, %rbp
        subq    $16, %rsp
        leaq    -4(%rbp), %rax
        movq    %rax, %rsi
        movl    $.LC0, %edi
        movl    $0, %eax
        call    __isoc99_scanf
        movl    -4(%rbp), %eax
        movl    $-1, %edx
        movl    %eax, %ecx
        sall    %cl, %edx
        movl    %edx, %eax
        notl    %eax
        movl    $0, %edx
        movl    $0, %esi
        movl    %eax, %edi
        call    t
        movl    %eax, %edx
        movl    -4(%rbp), %eax
        movl    %eax, %esi
        movl    $.LC1, %edi
        movl    $0, %eax
        call    printf
        movl    $0, %eax
        leave
        ret
