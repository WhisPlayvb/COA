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
err2 db "Source file could not be opened",10
len2 equ $-err2
err3 db "Destination file could not be opened",10
len3 equ $-err3
msg1 db "Copied Successfully!",10
len4 equ $-err3


section .bss
src resb 50
dest resb 50
fd1 resq 1
fd2 resq 1
fd3 resq 1
buffer resb 100
actl resq 1


section .text
global _start
_start: pop rcx 
cmp rcx,03
jne print_err1
pop rcx
pop rcx 
mov rsi,src
mov rdx,00
l1: mov bl,byte[rcx+rdx]
cmp bl,00H
je skip
mov byte[rsi+rdx],bl
inc rdx
jmp l1
skip: mov byte[rsi+rdx],00H ;'\0'
pop rcx
mov rsi,dest
mov rdx,00 
l2: mov bl,byte[rcx+rdx]
cmp bl,00H
je skip1
mov byte[rsi+rdx],bl
inc rdx
jmp l2
skip1: mov byte[rsi+rdx],00H
mov rax,02
mov rdi,src
mov rsi,00H
mov rdx,0777o
syscall
cmp rax,00
jle print_err2
mov qword[fd1],rax
mov rax,02
mov rdi,dest
mov rsi,00H
mov rdx,0777o
syscall
cmp rax,00H
jle create_file
mov [fd2],rax
mov rax,03
mov rdi,[fd2]
syscall
jmp open_second
create_file: mov rax,85
mov rdi,dest
syscall
open_second: mov rax,02
mov rdi,dest
mov rsi,0201H ;write - 0201
mov rdx,0777o
syscall
cmp rax,00
jle print_err3
mov [fd3],rax
up: mov rax,00
mov rdi,[fd1]
mov rsi,buffer
mov rdx,100
syscall
mov [actl],rax
mov rax,01
mov rdi,[fd3]
mov rsi,buffer
mov rdx,qword[actl]
syscall
cmp byte[actl],199
je up
mov rax,03
mov rdi,[fd1]
syscall
mov rax,03
mov rdi,[fd3]
syscall
WRITE msg1,len4
exit: mov rax,60
mov rdi,00
syscall
print_err1: WRITE err1,len1
jmp exit
print_err2: WRITE err2,len2
jmp exit
print_err3: WRITE err3,len3
jmp exit
