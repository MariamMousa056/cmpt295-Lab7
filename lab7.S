    # our static data
    .data
    .align 8
    .global fill_array
    .global dot
    .global dot_struct

seed: 
    # making a 64 bit seed which starts at 1
    .quad 1 
    
    # should be visible to other files
    .text 
    .global randint

randint : 
    movabs $6364136223846793005, %r8

    #loading the current seed from memory into rax
    mov seed(%rip), %rax
    # doing seed = seed * multiplier
    imul %r8, %rax

    # doing seed = seed + 1
    add $1, %rax

    # saving the new seed 
    mov %rax, seed(%rip)

    # return vale = seed >> 33 
    shr $33, %rax

    # returning our random number 
    ret

fill_array: 
dot: 
dot_struct: 
    mov $0, %rax
    ret