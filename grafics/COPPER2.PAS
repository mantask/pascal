
program copper; { COPPER2.PAS }
{ Pascal version of copper, by Bas van Gaalen }
uses u_vga,u_kb;
const
  pal:array[0..3*28-1] of byte=(
    4,4,2,8,8,4,12,12,6,16,16,8,20,20,10,24,24,12,28,28,14,32,32,16,36,36,
    18,40,40,20,44,44,22,48,48,24,52,52,26,52,52,26,56,56,28,56,56,28,60,
    60,30,60,60,30,60,60,30,63,63,33,63,63,33,63,63,33,63,63,33,63,63,33,
    60,60,30,56,56,28,52,52,26,48,48,24);

procedure copperbars;
var l:word; lo,lc,cc:byte;
begin
  asm cli end;
  l:=380; lo:=1;
  vretrace;
  while l<>0 do begin
    lc:=lo; inc(lo); cc:=0;
    while (lc<>0) and (l<>0) do begin
      port[$3c8]:=0;
      port[$3c9]:=pal[cc];
      port[$3c9]:=pal[cc+1];
      while (port[$3da] and 1) <> 0 do;
      while (port[$3da] and 1) = 0 do;
      port[$3c9]:=pal[cc+2];
      inc(cc,3); dec(lc); dec(l);
    end;
  end;
  asm sti end;
end;

begin
  repeat copperbars; until keypressed;
end.
