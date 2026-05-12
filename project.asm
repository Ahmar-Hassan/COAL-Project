org 100h

jmp start



password db 'admin123'
plen equ 8

menu db 13,10,'========== MENU ==========',13,10
     db '1. Login',13,10
     db '2. Exit',13,10
     db 'Enter Choice: $'

msg1 db 13,10,'Enter Password: $'
msg2 db 13,10,'Access Granted! $'
msg3 db 13,10,'Access Denied! $'
msg4 db 13,10,'SYSTEM LOCKED! $'
msg5 db 13,10,'Invalid Choice! $'

newline db 13,10,'$'

input:
    db 20
    db 0
    times 20 db 0

attempts db 3

choice db 0



start:

main_menu:

    ; Display menu
    mov dx, menu
    mov ah, 09h
    int 21h

    ; Take choice
    mov ah, 01h
    int 21h

    mov [choice], al

    ; Compare choice
    cmp al, '1'
    je login

    cmp al, '2'
    je exit

    ; Invalid choice
    mov dx, msg5
    mov ah, 09h
    int 21h

    jmp main_menu



login:

    ; Check attempts
    mov al, [attempts]
    cmp al, 0
    je locked

    ; New line
    mov dx, newline
    mov ah, 09h
    int 21h

    ; Display password message
    mov dx, msg1
    mov ah, 09h
    int 21h

    ; Take password input
    mov dx, input
    mov ah, 0Ah
    int 21h

    ; Check length
    mov al, [input + 1]
    cmp al, plen
    jne fail

    ; Compare passwords
    mov si, password
    mov di, input + 2
    mov cx, plen

compare_loop:

    mov al, [si]
    mov bl, [di]

    cmp al, bl
    jne fail

    inc si
    inc di

    loop compare_loop



success:

    mov dx, msg2
    mov ah, 09h
    int 21h

    jmp exit



fail:

    dec byte [attempts]

    mov dx, msg3
    mov ah, 09h
    int 21h

    mov dx, newline
    mov ah, 09h
    int 21h

    jmp main_menu


locked:

    mov dx, msg4
    mov ah, 09h
    int 21h

    jmp exit


exit:

    mov ah, 4Ch
    int 21h