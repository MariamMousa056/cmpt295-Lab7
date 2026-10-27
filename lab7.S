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
    push %r12
    push %r13
    push %r14

    # well use r12 as our array pointer
    mov %rdi, %r12
    # well use r13 to save our n
    mov %rsi, %r13 
    # well use r14 to save our i
    mov $0, %r14
fill_loop: 
    # first well compare i with n 
    cmp %r13, %r14
    # well jump when i >= n
    jge fill_done

    call randint
    # ^ now we have a random number in rax, we only want the lower 8 bits
    and $0xff, %rax
    sub $128, %rax

    # array[i] = rax
    # address = r12 + r14 * 8 (because each element is 8 bytes)
    mov %rax, (%r12, %r14,8)

    # incrementing our counter i 
    add $1, %r14
    # repeating 
    jmp fill_loop
fill_done: 
    pop %r14
    pop %r13
    pop %r12
    ret
    
dot: 
    # rax will hold our sum, which starts at 0
    mov $0, %rax
    # rcx will be our i which also starts at 0
    mov $0, %rcx
dot_loop: 
    # compare i with n
    cmp    %rdx, %rcx         
    jge    dot_done            

    # arr1[i] will be in r8
    mov    (%rdi,%rcx,8), %r8  

    # doing the multiplication array1[i] * array2[i]
    imul   (%rsi,%rcx,8), %r8 
    # sum = sum + r8
    add    %r8, %rax           

    # incrementing i 
    add    $1, %rcx    
    # going to the top of the loop again         
    jmp    dot_loop
dot_done:
    ret         

dot_struct:
    # rax will hold our sum and will start at 0
    mov    $0, %rax            # rax = sum = 0
    # rcx will be pair counter and also starts at 0
    mov    $0, %rcx            # rcx = i = 0 (just counts pairs)

dot_struct_loop:
    # comparing i with n 
    cmp    %rsi, %rcx 
    # jumping if i >= n        
    jge    dot_struct_done   


    mov    0(%rdi), %r8        
    imul   8(%rdi), %r8       
    add    %r8, %rax          

    # moving our pointer to the next pair (which is 16 bytes away)
    add    $16, %rdi    
    # incrementing i       
    add    $1, %rcx        
    # going to the top of the loop    
    jmp    dot_struct_loop
dot_struct_done:
    ret                       