Procedure waitRetrace; Assembler;
asm
   mov dx,3DAh
@@1:
   in al,dx
   and al,08h
   jnz @@1
@@2:
   in al,dx
   and al,08h
   jz  @@2
end;
