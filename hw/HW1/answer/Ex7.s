.text
	.globl	main

f:
    pushq %rbp
    movq %rsp, %rbp
    subq $32, %rsp
    movl %edi, -4(%rbp) # save i

    cmpl $15, -4(%rbp) # if i == N return
    je endfwithzero

    movl %esi, -8(%rbp) # save c
    shll $4, %esi
    orl -4(%rbp), %esi 
    movl %esi, -12(%rbp) # save key
    lea memo(%rip), %rdi
    movl (%rdi,%rsi, 4), %edi # get memo[key]
    movl %edi, -16(%rbp) # save r

    cmpl $0, %edi # if r != 0 return r
    jne endfwithr
    movl $0, -20(%rbp) # s
    movl $0, -24(%rbp) # j
    jmp checkiter

itercalsum:
    movl -24(%rbp), %ecx # take j
    movl $1, %esi
    shll %ecx, %esi
    movl %esi, -28(%rbp) # col = 1 << j
    andl  -8(%rbp), %esi
    testl %esi, %esi # if (c & col) == 0 continue
    je addj

# call self again
    movl -4(%rbp), %edi # i
    incl %edi
    movl -28(%rbp), %eax # col
    movl -8(%rbp), %esi # c
    subl %eax, %esi
    call f

# m[i][j] + return val
# offset=(i×M+j)×sizeof(long)
    movl -4(%rbp), %edi # i
    movl -24(%rbp), %esi # j
    movl $15, %ecx # M
    imul %edi, %ecx
    addl %esi, %ecx
    shll $2, %ecx
    leaq m(%rip), %rdi
    movl (%rdi, %rcx), %edi 
    movl %edi, -32(%rbp) # save x = m[i][j]
    addl %eax, -32(%rbp) # x + f
    movl -20(%rbp), %eax # take s
    cmpl -32(%rbp), %eax # x>s
assigns:
    cmovl -32(%rbp), %eax #if true set x = s
    movl %eax, -20(%rbp) 

addj:
    incl -24(%rbp)

checkiter:
    cmpl $15,-24(%rbp) # J < N
    jl itercalsum

endfwithanwser:
    movl -20(%rbp), %eax
    movl -12(%rbp), %esi
    lea memo(%rip), %rdi
    movl %eax, (%rdi,%rsi, 4) # save memo[key] with s
    leave
    ret

endfwithr:
    mov -16(%rbp), %eax
    leave
    ret

endfwithzero:
    mov $0, %eax
    leave
    ret

main:
    pushq %rbp
    movq %rsp, %rbp
    movl $0, %edi
    movl $1, %esi
    shll $15, %esi
    subl $1, %esi
    call f
    
    movl %eax, %esi
    leaq message(%rip), %rdi # take message
    xorq %rax, %rax
    call printf

    xorq %rax, %rax
    leave
    ret

message:
    .string "solution = %d\n"

.data
m:
	.long	7
	.long	53
	.long	183
	.long	439
	.long	863
	.long	497
	.long	383
	.long	563
	.long	79
	.long	973
	.long	287
	.long	63
	.long	343
	.long	169
	.long	583
	.long	627
	.long	343
	.long	773
	.long	959
	.long	943
	.long	767
	.long	473
	.long	103
	.long	699
	.long	303
	.long	957
	.long	703
	.long	583
	.long	639
	.long	913
	.long	447
	.long	283
	.long	463
	.long	29
	.long	23
	.long	487
	.long	463
	.long	993
	.long	119
	.long	883
	.long	327
	.long	493
	.long	423
	.long	159
	.long	743
	.long	217
	.long	623
	.long	3
	.long	399
	.long	853
	.long	407
	.long	103
	.long	983
	.long	89
	.long	463
	.long	290
	.long	516
	.long	212
	.long	462
	.long	350
	.long	960
	.long	376
	.long	682
	.long	962
	.long	300
	.long	780
	.long	486
	.long	502
	.long	912
	.long	800
	.long	250
	.long	346
	.long	172
	.long	812
	.long	350
	.long	870
	.long	456
	.long	192
	.long	162
	.long	593
	.long	473
	.long	915
	.long	45
	.long	989
	.long	873
	.long	823
	.long	965
	.long	425
	.long	329
	.long	803
	.long	973
	.long	965
	.long	905
	.long	919
	.long	133
	.long	673
	.long	665
	.long	235
	.long	509
	.long	613
	.long	673
	.long	815
	.long	165
	.long	992
	.long	326
	.long	322
	.long	148
	.long	972
	.long	962
	.long	286
	.long	255
	.long	941
	.long	541
	.long	265
	.long	323
	.long	925
	.long	281
	.long	601
	.long	95
	.long	973
	.long	445
	.long	721
	.long	11
	.long	525
	.long	473
	.long	65
	.long	511
	.long	164
	.long	138
	.long	672
	.long	18
	.long	428
	.long	154
	.long	448
	.long	848
	.long	414
	.long	456
	.long	310
	.long	312
	.long	798
	.long	104
	.long	566
	.long	520
	.long	302
	.long	248
	.long	694
	.long	976
	.long	430
	.long	392
	.long	198
	.long	184
	.long	829
	.long	373
	.long	181
	.long	631
	.long	101
	.long	969
	.long	613
	.long	840
	.long	740
	.long	778
	.long	458
	.long	284
	.long	760
	.long	390
	.long	821
	.long	461
	.long	843
	.long	513
	.long	17
	.long	901
	.long	711
	.long	993
	.long	293
	.long	157
	.long	274
	.long	94
	.long	192
	.long	156
	.long	574
	.long	34
	.long	124
	.long	4
	.long	878
	.long	450
	.long	476
	.long	712
	.long	914
	.long	838
	.long	669
	.long	875
	.long	299
	.long	823
	.long	329
	.long	699
	.long	815
	.long	559
	.long	813
	.long	459
	.long	522
	.long	788
	.long	168
	.long	586
	.long	966
	.long	232
	.long	308
	.long	833
	.long	251
	.long	631
	.long	107
	.long	813
	.long	883
	.long	451
	.long	509
	.long	615
	.long	77
	.long	281
	.long	613
	.long	459
	.long	205
	.long	380
	.long	274
	.long	302
	.long	35
	.long	805
        .bss
memo:
    .space	2097152

## Local Variables:
## compile-command: "gcc matrix.s && ./a.out"
## End:

