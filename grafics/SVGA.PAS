
program tseng_svga; { SVGA.PAS }
{ Small SuperVGA demonstration without BGI, GRAPH or any unit or library.
  Works only on TsengLabs ET-3000/4000 or compatibles!
  By Bas van Gaalen. }
uses u_vga,u_kb;
const yofs=100;

procedure putpixel(x,y:word; c:byte); assembler;
asm
  mov es,u_vidseg
  mov ax,640
  mul y
  add ax,x
  adc dx,0
  mov di,ax
  mov al,dl
  mov dx,03cdh
  out dx,al
 @skip:
  mov al,c
  mov es:[di],al
end;

function getpixel(x,y:word):byte; assembler;
asm
  mov es,u_vidseg
  mov ax,640
  mul y
  add ax,x
  adc dx,0
  mov di,ax
  mov al,dl
  mov dx,03cdh
  shl al,4
  out dx,al
 @skip:
  mov al,es:[di]
end;

var x,y:word; i:byte;
begin
  setvideo($2e); { 02eh=640x480x256 }
  putpixel(320,pred(yofs),7);
  for y:=0 to 254 do
    for x:=319-y to 321+y do begin
      i:=getpixel(pred(x),yofs+pred(y)) xor getpixel(succ(x),yofs+pred(y));
      if i>0 then putpixel(x,yofs+y,i);
    end;
  waitkey(0);
  setvideo(u_lm);
end.
