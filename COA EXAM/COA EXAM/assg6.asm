extern printf,scanf

%macro PRINT 02 
push rbp
mov rax,00H
mov rdi,%1
mov rsi,%2
call printf
pop rbp
%endmacro

%macro SCAN 02
push rbp
mov rax,00H
mov rdi,%1
mov rsi,%2
call scanf
pop rbp
%endmacro

%macro PRINTFLOAT 02
push rbp
mov rax,01
mov rdi,%1
movsd xmm0,%2
call printf
pop rbp
%endmacro

section .data
msg1 db "Enter the three numbers",10,0
fmt1 db "%lf",0
fmt2 db "%s",0
msg2 db "Roots are ",10


section .bss
a resb 08
b resb 08
c resb 08
r1 resb 08
r2 resb 08
t1 resb 08
t2 resb 08
t3 resb 08
t4 resb 08
temp resw 01


section .text
global main
main: PRINT fmt2,msg1
SCAN fmt1,a
SCAN fmt1,b
SCAN fmt1,c
finit
fld qword[b]
fmul st0,st0
fstp qword[t1]
fld qword[a]
fmul qword[c]
mov word[temp],04
fimul word[temp]
fstp qword[t2]
fld qword[t1]
fsub qword[t2]
fstp qword[t1]
fld qword[b]
fchs 
fstp qword[t2]
mov word[temp],02
fld qword[a]
fimul word[temp]
fstp qword[t3]
fld qword[t1]
fabs
fsqrt 
fstp qword[t4]
cmp qword[t1],00H
je equal_roots
PRINT fmt2,msg2
fld qword[t2]
fadd qword[t4]
fdiv qword[t3]
fstp qword[r1]
PRINTFLOAT fmt1,qword[r1]
equal_roots: fld qword[t2]
fsub qword[t4]
fdiv qword[t3]
fstp qword[r2]
PRINTFLOAT fmt1,qword[r2] 
mov rax,00
ret
