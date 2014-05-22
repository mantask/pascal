{MK 2001}
{lietuvos informatikos olimpiada 3 etapo 2 dalis jaunesniesiems}
{Ideja:
 palikti priesinikui kvadrata, nes turint kvadrata neimanoma laimeti.
 Jei kvadrata jau turi, tai kasti viska tik paliekant viena eilute
 Laimejimu ir pralaimejimu lentele:

   1 2 3 4 5 6 .
 1 - + + + + + + .
 2 + - + + + + + .
 3 + + - + + + + .
 4 + + + - + + + .
 5 + + + + - + + .
 6 + + + + + - + .
 . + + + + + + - .
   . . . . . . . .
 }
program Sokolado_valgymas;
  var kiek, aukstis, ilgis : byte;
      vert, laimi : boolean;
      f : text;
begin
  {duomenys}
  assign (f, 'soko.dat');
  reset (f);
  read (f, aukstis, ilgis);
  close (F);

  {sprendimas}
  if ilgis = aukstis then
  begin
    laimi := false;
    vert := true;
    kiek := ilgis - 1;
  end
  else begin
    laimi := true;
    kiek := abs (aukstis - ilgis);
    if aukstis > ilgis then vert := false
                       else vert := true
  end;

  {rezultatai}
  assign (f, 'soko.rez');
  rewrite (f);
  if laimi then write (f, 'L ')
           else write (f, 'P ');
  if vert then write (f, 'V ')
          else write (f, 'H ');
  writeln (f, kiek);
  close (f);
end.