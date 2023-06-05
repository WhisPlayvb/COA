%macro WRITE 02
mov rax,1
mov rdi,1
mov rsi,%1
mov rdx,%2
syscall

%endmacro
section .data
err1 db "Parameters not matching",10
len1 equ $-err1
err2 db "File dosent exist",10
len2 equ $-err2
msg1 db "File Deleted!",10
len3 equ $-msg1


section .bss
fname resb 20
fd resq 1
section .text


global _start
_start: pop rcx
cmp rcx,02
jne print_err1
pop rcx
pop rcx
mov rsi,fname
mov rdx,00H
up: mov bl,byte[rcx+rdx]
cmp bl,00H
je l1
mov byte[rsi+rdx],bl
inc rdx
jmp up
l1: mov byte[rsi+rdx],00H
mov rax,02H
mov rdi,fname
mov rsi,00H
mov rdx,0777o
syscall
cmp rax,00
jle print_err2
mov [fd],rax
mov rax,03
mov rdi,[fd]
syscall
mov rax,87
mov rdi,fname
syscall
WRITE msg1,len3
exit: mov rax,60
mov rdi,00
syscall
print_err1: WRITE err1,len1
jmp exit
print_err2: WRITE err2,len2
jmp exit
