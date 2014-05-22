
program plasma; { PLASMA2.PAS }
{ Assembler/Mode-13h version of Plasma, by Bas van Gaalen }
uses u_vga,u_pal;
var stab:array[0..255] of byte; i1,j1:byte;

procedure doplasma; assembler;
asm
  mov es,u_vidseg
 @run:
  call vretrace
  add i1,1
  add j1,1
  mov si,5
  mov ax,si
  shl ax,6
  mov di,ax
  shl ax,4
  add di,ax
  add di,20
 @l0:
  xor bh,bh
  mov bl,i1
  add bx,si
  and bx,$ff
  mov dl,byte ptr stab[bx]
  xor bh,bh
  mov bl,j1
  mov dh,byte ptr stab[bx]
  mov cx,10
 @l1:
  mov bx,dx
  add bx,cx
  xor bh,bh
  mov al,byte ptr stab[bx]
  mov bx,dx
  shr bx,8
  add bx,si
  xor bh,bh
  add al,byte ptr stab[bx]
  mov ah,al
  mov [es:di],ax
  add di,2
  add ax,$1010               { disortion }
  mov [es:di],ax
  add di,318
  mov [es:di],ax
  sub ax,$1010               { disortion }
  add di,2
  mov [es:di],ax
  sub di,318
  inc cx
  cmp cx,80
  jne @l1
  add di,360
  inc si
  cmp si,85
  jne @l0
  in al,$60
  cmp al,$80
  ja @run
end;

var i:byte;
begin
  setvideo($13);
  for i:=0 to 255 do
    setrgb(i,32+trunc(31*sin(i*pi/128)),
             32+trunc(31*sin(i*pi*2/128)),
             32+trunc(31*cos(i*pi*4/128)));
  for i:=0 to 255 do stab[i]:=round(sin(2*pi*i/255)*128)+128;
  i1:=50; j1:=90;
  doplasma;
  setvideo(u_lm);
end.
