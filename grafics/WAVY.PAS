
program wavy; { WAVY.PAS }
{ Small demo for the 'use' of sine-tables, by Bas van Gaalen }
uses
  u_vga,u_pal,u_kb;
const
  add1=1; add2=-1; add3=-1;
var
  ptab,ctab:array[0..319] of byte;
  stab1,stab2,stab3:array[0..255] of byte;
  i,i1,i2,i3:word;

begin
  for i:=0 to 255 do begin
    stab1[i]:=round(sin(i*2*pi/255)*50)+99;
    stab2[i]:=round(cos(i*4*pi/255)*25);
    stab3[i]:=round(sin(i*4*pi/255)*25);
  end;
  fillchar(ctab,sizeof(ctab),0);
  setvideo($13);
  for i:=1 to 199 do setrgb(i,i div 4,20+i div 5,10+i div 6);
  i1:=0; i2:=25; i3:=100;
  repeat
    move(ctab,ptab,sizeof(ctab));
    vretrace;
    for i:=0 to 319 do begin
      ctab[i]:=stab1[(i+i1) mod 255]+stab2[(i+i2) mod 255]+stab3[(i+i3) mod 255];
      putpixel(i,ptab[i],0);
      putpixel(i,ctab[i],ctab[i]);
    end;
    i1:=(i1+add1) mod 255; i2:=(i2+add2) mod 255; i3:=(i3+add3) mod 255;
  until keypressed;
  setvideo(u_lm);
end.
