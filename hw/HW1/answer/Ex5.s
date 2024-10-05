.text
.globl main

printint:
    pushq %rbp
    movq %rsp, %rbp

    movl %edi, %esi

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
    subq $16, %rsp # allocate local variable space.

# print(let x = 3 in x * x)
    movl $3, -4(%rbp) # allocate x
    movl -4(%rbp), %eax
    mull %eax 
    movl %eax, %edi
    call printint

# print(let x = 3 (in let y = x * x in x * y) + (let z = x + 3 in z/z))
    movl -4(%rbp), %edi # take x
    movl %edi, %eax
    addl %eax, %eax # x + x
    movl %eax, -8(%rbp) # set y
    mull %edi ;# x * y
    movl %eax, %r8d # take l result to r8d

    movl %edi, %eax
    add $3, %eax
    movl %eax, -12(%rbp)
    divl %eax
    addl %r8d, %eax
    

    movl %eax, %edi
    call printint


    mov $0, %rax # exit code
    leave
    ret

