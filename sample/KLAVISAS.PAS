{ MK 2001 }
{ rodo klavisu 1, 2, 3, 4 paspaudimo busenas
  bei paraso paspausto klaviso koda }
program klav;
  uses crt;
  var sk: byte;
      myg : char;
      keys : array [1 .. 128] of boolean;
begin
 clrscr;
 repeat
    sk := port[$60];
    if sk < $80 then keys [sk] := true
                else keys [sk - 128] := false;

    gotoxy (5, 3); writeln (keys [2] :7, keys [3] :7, keys [4] :7, keys [5] :7);
    write (sk :3);

    while keypressed do readkey

 until sk = 01; { Esc nutraukia }
end.

