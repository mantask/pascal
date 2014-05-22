
program bounce; { BOUNCE.PAS }
{ "How to generate 'realistic' bounce", by Bas van Gaalen }
uses u_vga;
const idiv=2;
var j:real; i,pi,px,py,x,y:integer; dir:shortint;
begin
  setvideo($13);
  x:=10; y:=0; dir:=1; i:=190;
  while i>0 do begin
    j:=-sqrt(i);
    while j<sqrt(i) do begin
      y:=round(sqr(j));
      px:=x; py:=y; pi:=i;
      putpixel(x,y+(190-i),15);
      inc(x,dir); if (x>310) or (x<10) then dir:=-dir;
      j:=j+0.2;
      vretrace;
      putpixel(px,y+(190-pi),0);
    end;
    if (i div idiv)=0 then i:=0 else dec(i,i div idiv);
  end;
  setvideo(u_lm);
end.
