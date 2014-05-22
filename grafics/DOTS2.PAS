
program dots2; { DOTS2.PAS }
{ Good ol' pc effect ;-) by Bas van Gaalen }
uses u_vga,u_pal,u_kb;
const
  dots=800;
  slen1=1100; samp1=49; sofs1=50;
  slen2=1200; samp2=39; sofs2=50;
  dx1=3; dy1=5; xspd1=4; yspd1=2;
  dx2=4; dy2=3; xspd2=2; yspd2=3;
var
  stab1:array[0..slen1] of byte;
  stab2:array[0..slen2] of byte;

procedure plotter;
var xst1,xst2,yst1,yst2,i,j,offset,onset:word;
begin
  xst1:=100; xst2:=800; yst1:=300; yst2:=700;
  repeat
    vretrace;
    for i:=0 to dots do begin
      offset:=((stab1[(yst1+i*dy1) mod slen1]+stab2[(yst2+i*dy2) mod slen2])*320)+
        (stab1[(xst1+i*dx1) mod slen1])+(stab2[(xst2+i*dx2) mod slen2])+60;
      onset:=((stab1[(yst1+yspd1+i*dy1) mod slen1]+stab2[(yst2+yspd2+i*dy2) mod slen2])*320)+
        (stab1[(xst1+xspd1+i*dx1) mod slen1])+(stab2[(xst2+xspd2+i*dx2) mod slen2])+60;
      mem[u_vidseg:offSet]:=0;
      mem[u_vidseg:onSet]:=32+i mod 32;
    end;
    xst1:=(xst1+xspd1) mod slen1; yst1:=(yst1+yspd1) mod slen1;
    xst2:=(xst2+xspd2) mod slen2; yst2:=(yst2+yspd2) mod slen2;
  until keypressed;
end;

var i:word;
begin
  setvideo($13);
  for i:=0 to slen1 do stab1[i]:=round(sin(i*(4*pi)/slen1)*samp1)+sofs1;
  for i:=0 to slen2 do stab2[i]:=round(sin(i*(4*pi)/slen2)*samp2)+sofs2;
  plotter;
  setvideo(u_lm);
end.
