program matrix;
   uses crt;
   const pask = 10;
   var m : array [1 .. pask, 1 .. pask] of byte;
       x, y, pg : byte;
begin
   clrscr;
   for x := 1 to pask do
    begin
     for y := 1 to pask do
       begin
         m [x, y] := random (100);
         if (x = y) or (y = pask - x + 1) then
          begin
            textcolor (5);
            write (m [x, y] :5);
            textcolor (7);
          end
         else write (m [x, y] :5);
       end;
       writeln;
     end;
   for x := 1 to pask do
    begin
      y := x;
      pg := m [x, y];
      m [x, y] := m [pask - x + 1, y];
      m [pask - x + 1, y] := pg
    end;
  writeln;
  writeln;
  for x := 1 to pask do
   begin
    for y := 1 to pask do
     if (x = y) or (y = pask - x + 1) then
      begin
        textcolor (5);
        write (m [x, y] :5);
        textcolor (7);
      end
     else write (m [x, y] :5);
    writeln
   end;
  readkey;
end.
