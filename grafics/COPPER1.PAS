
program copper; { COPPER1.PAS }
{ Assembler version of a very simple general copper, by Bas van Gaalen }
uses u_vga,u_kb;
const
  pal:array[0..3*28-1] of byte=(
    4,2,2,8,4,4,12,6,6,16,8,8,20,10,10,24,12,12,28,14,14,32,16,16,36,18,18,
    40,20,20,44,22,22,48,24,24,52,26,26,52,26,26,56,28,28,56,28,28,60,30,
    30,60,30,30,60,30,30,63,33,33,63,33,33,63,33,33,63,33,33,63,33,33,60,
    30,30,56,28,28,52,26,26,48,24,24);

procedure copperbars(var colors; lines:word; count:byte); assembler;
asm
  cli
  cld
  push ds
  mov ah,0
  mov dh,3
 @l0:
  call vretrace
  mov bh,1
  mov di,[lines]
 @l1:
  mov bl,bh
  inc bh
  lds si,[colors]
 @l2:
  mov dl,0c8h
  mov al,ah
  out dx,al
  inc dx
  outsb
  outsb
  mov dl,0dah      { horizontal retrace }
 @hor1:
  in al,dx
  test al,1
  jnz @hor1
 @hor2:
  in al,dx
  test al,1
  jz @hor2
  mov dl,0c9h
  outsb
  dec di
  jz @out
  dec bl
  jnz @l2
  jmp @l1
 @out:
  dec count
  jnz @l0
  pop ds
  sti
end;

begin
  repeat copperbars(pal,380,8); until keypressed;
end.
