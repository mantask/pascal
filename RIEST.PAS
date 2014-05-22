{ MK 2001 }
{ programa is JPM stovyklos }
Program riestainiai;

var
  ck,
  pg,
  skait,          { riestainiu skaicius }
  vard : byte; { zmoniu skaicius }
  f : text; { duomenys }
  dalikliai : array [0 .. 4] of byte; { vard dalikliai }

begin
  { nuskaitom pradinius duomenis }
  assign (f, 'riest.dat');
  reset (f);
  readln (f, skait, vard);
  close (F);
  { ieskom dalikliu }
  dalikliai [0] := 0;
  for ck := vard div 2 downto 2 do
  if vard mod ck = 0 then
  begin
    inc (dalikliai [0]);
    dalikliai [dalikliai [0]] := ck;
  end;

  assign (f, 'riest.rez');
  rewrite (f);
  { kiek iseina pasidalinti be pjaustymu }
  if skait div vard <> 0 then
  begin
    pg := skait - skait mod vard;
    writeln (f, pg, ' 1 ', pg div vard);
    dec (skait, pg);
  end;
  { bandom likucius pjaustyti }
  for ck := 1 to dalikliai [0] do
  if skait div dalikliai [ck] > 0 then
  begin
    pg := skait - skait mod dalikliai [ck];
    writeln (f, pg, ' ', vard div dalikliai [ck], ' ', pg div dalikliai [ck]);
    dec (skait, pg);
  end;
  { viska dalijame is zmoniu skaicius ir po dali kiekvienam, jei liko }
  if skait <> 0 then
  writeln (f, skait, ' ', vard, ' 1');
  close (f);
end.