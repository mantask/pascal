program drakonas;
   uses crt, graph;
   const il = 3;
   var kr : array [0 .. 60000] of 0 .. 3;
       gm, gd, x, y, l, n, ck1, ck : integer;
begin
    n := 15;
    l := 1;
    kr [l] := 0;
    for ck := 2 to n do
      begin
         for ck1 := 1 to l do kr [l + l - ck1 + 1] := (kr [ck1] + 1) mod 4;
         inc (l, l)
      end;

    x := 150; y := 150;
    gm := detect;
    initgraph (gm, gd, '');
    for ck := 1 to l do
        case kr [ck] of
          0 : begin line (x, y, x, y - il); dec (y, il) end;
          1 : begin line (x, y, x - il, y); dec (x, il) end;
          2 : begin line (x, y, x, y + il); inc (y, il) end;
          3 : begin line (x, y, x + il, y); inc (x, il) end
        end;
    readkey

end.

