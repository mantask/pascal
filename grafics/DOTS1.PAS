
program dots1; { DOTS1.PAS }
{ Good ol' c64 effect, by Bas van Gaalen }
uses u_vga,u_pal,u_kb;
const
  dots=75;
  fade=5;
  slen1=600; samp1=49; sofs1=50;
  slen2=300; samp2=39; sofs2=50;
  dx1=2; dy1=3; xspd1=3; yspd1=2;
  dx2=3; dy2=2; xspd2=2; yspd2=3;
var
  stab1:array[0..slen1] of byte;
  stab2:array[0..slen2] of byte;

procedure plotter;
var xst1,xst2,yst1,yst2,i,j,offset,onset:word;
begin
  xst1:=50; xst2:=130; yst1:=0; yst2:=70;
  repeat
    vretrace;
    for j:=0 to 9 do
      for i:=0 to dots do begin
        offset:=((stab1[(yst1+i*dy1) mod slen1]+stab2[(yst2+i*dy2) mod slen2])*320)+
          (stab1[(xst1+i*dx1) mod slen1])+(stab2[(xst2+i*dx2) mod slen2])+60;
        onset:=((stab1[(yst1+yspd1*fade*j+i*dy1) mod slen1]+stab2[(yst2+yspd2*fade*j+i*dy2) mod slen2])*320)+
          (stab1[(xst1+xspd1*fade*j+i*dx1) mod slen1])+(stab2[(xst2+xspd2*fade*j+i*dx2) mod slen2])+60;
        mem[u_vidseg:offSet]:=0;
        mem[u_vidseg:onSet]:=18+5*j;
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
  for i:=0 to 63 do setrgb(i,i div 3,i div 2,i div 2);
  plotter;
  setvideo(u_lm);
end.
