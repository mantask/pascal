
program smoothtextscroll; { SCR_SMTH.PAS }
{ HSTS, by Bas van Gaalen.
  Tested on 386dx/40, 486dx2/66, 486-laptop, 486dx, all fine... }
uses u_vga,u_mdx,u_txt,u_kb;
const
  vidseg:word=$b800; lines=16;
  txt:string=' Hardware-Smooth-Text-Scroll. Made by Bas van Gaalen '+
    'and Sven van Heel...    ';
var fofs,fseg:word;

procedure setup(ad:word); assembler;
asm
  push bp
  mov ax,1130h
  mov bh,6
  int 10h
  mov fseg,es
  mov fofs,bp
  pop bp

  mov dx,3d4h
  mov al,18h
  mov ah,[byte(ad)]
  out dx,ax
  mov al,7
  out dx,al
  inc dx
  in al,dx
  dec dx
  mov ah,[byte(ad)+1]
  and ah,00000001b
  shl ah,4
  and al,11101111b
  or al,ah
  mov ah,al
  mov al,7
  out dx,ax

  mov al,9
  out dx,al
  inc dx
  in al,dx
  dec dx
  mov ah,[byte(ad)+1]
  and ah,00000010b
  shl ah,5
  and al,10111111b
  or al,ah
  mov ah,al
  mov al,9
  out dx,ax

  mov dx,03c0h
  mov al,10h+32
  out dx,al
  inc dx
  in al,dx
  and al,11011111b
  or al,00100000b
  dec dx
  out dx,al

  mov dx,03d4h
  mov al,11h
  out dx,al
  inc dx
  in al,dx
  and al,7fh
  mov ah,al
  mov al,11h
  dec dx
  out dx,ax
  mov ax,4e01h
  out dx,ax
  mov ax,0105h
  out dx,ax
  mov al,11h
  out dx,al
  inc dx
  in al,dx
  or al,80h
  mov ah,al
  mov al,11h
  dec dx
  out dx,ax
end;

procedure setsmooth(smt:byte); assembler;
asm
  mov dx,03c0h
  mov al,13h+32
  out dx,al
  inc dx
  in al,dx
  and al,11110000b
  mov ah,smt
  or al,ah
  dec dx
  out dx,al
end;

var x,y,i,ch:word; cx,tidx:byte;
begin
  setvideo(3);
  setup(lines*16);
  mdx_setaddress((25-lines)*80);
  dspat('Hey, a REAL smooth textscroll!',3,0,7); { note the pos! }
  x:=0; cx:=0; tidx:=1; i:=8;
  repeat
    vretrace;
    setsmooth(x);
    x:=(3+x) mod 9;
    if x=6 then begin
      ch:=byte(txt[tidx]) shl 4;
      for y:=0 to lines-1 do begin
        move(mem[vidseg:(25-lines+y)*160+4],mem[vidseg:(25-lines+y)*160+2],158);
        if boolean((mem[fseg:fofs+ch+y] shr i) and 1) then
          memw[vidseg:(25-lines+y)*160+158]:=$1fdb else
          memw[vidseg:(25-lines+y)*160+158]:=$1020;
      end;
      i:=(i-1) mod 8; if not boolean(i) then tidx:=1+tidx mod length(txt);
    end;
  until keypressed;
  setvideo(u_lm);
end.
