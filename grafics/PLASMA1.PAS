
program plasma; { PLASMA1.PAS}
{ Pascal/Mode-x version of Plasma, by Bas van Gaalen }
uses u_vga,u_mdx,u_pal,u_kb;
var stab1,stab2:array[0..255] of byte; x,y:word; i1,i2,j1,j2,c:byte;
begin
  mdx_setmodex(mdx_320x200,320);
  asm mov dx,03d4h; mov ax,4609h; out dx,ax; end;
  for x:=0 to 63 do begin
    setrgb(x,x div 4,x div 2,x);
    setrgb(127-x,x div 4,x div 2,x);
    setrgb(127+x,x,x div 4,x div 2);
    setrgb(254-x,x,x div 4,x div 2);
  end;
  for x:=0 to 255 do begin
    stab1[x]:=round(sin(2*pi*x/255)*128)+128;
    stab2[x]:=round(cos(2*pi*x/255)*128)+128;
  end;
  i1:=50; j1:=90; mdx_ofs:=0;
  repeat
    vretrace;
    setborder(80);
    mdx_ofs:=16000-mdx_ofs;
    mdx_setaddress(mdx_ofs);
    inc(i1,-1);
    inc(j1,2);
    for y:=0 to 56 do begin
      i2:=stab1[(y+i1) mod 255];
      j2:=stab1[j1 mod 255];
      for x:=0 to 79 do begin
        c:=stab1[(x+i2) mod 255]+stab2[(y+j2) mod 255];
        mem[u_vidseg:mdx_ofs+y*80+x]:=c mod 255;
      end;
    end;
    setborder(0);
  until keypressed;
  setvideo(u_lm);
end.
