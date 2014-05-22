{$A-,B-,D+,E+,F-,G-,I+,L+,N+,O-,P-,Q-,R-,S+,T-,V+,X+}
type screen = array [1..200, 1..320] of byte;
var r: real;
    x, y, i, m: longint;
    scr: screen absolute $A000:$0;
procedure setpal(num, r, g, b: byte);
begin
  port [$3C8] := num;
  port [$3C9] := R;
  port [$3C9] := G;
  port [$3C9] := B
end;
procedure delay(w: longint);
var l: longint;
begin
  for l := 1 to w*7500 do l := l
end;
begin
  asm
    mov ax,19
    int 10h
  end;
  for i := 0 to 63 do setpal(i, i, i, i);
  for i := 64 to 127 do setpal(i, 127 - i, 127 - i, 127 - i);
  for x := 1 to 320 do
    for y := 1 to 200 do
    begin
      r := sqrt(sqr(160 - x) + sqr(100 - y))*ArcTan(x / y + random(2));
      scr [y, x] := round(r) mod 128 ;
    end;
  m := 0;
  repeat
    for i := 0 to 63 do setpal((i + m) mod 128, i, i, i);
    for i := 64 to 127 do setpal((i + m) mod 128, 127 - i, 127 - i, 127 - i);
    inc(m);
    if m > 127 then m := 0;
    delay(10);
  until port [$60] = 1;
end.

