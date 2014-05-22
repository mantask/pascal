{ MK 2001 }
{ 12 olimpiados III etapo II dalies 4 uzdavinys }
Program daugianariai;

type
  Tnarys = record
             kof : word;
             n1, n2 : char;
           end;
  Tnariai = array [1 .. 65] of Tnarys;

var
  nariai : Tnariai;
  {rysiai : array [1 .. 32] of}
  sk : word;

procedure skaitymas (var sk : word; var nariai : Tnariai);
var
  pgeil : string;
  pgsk, pgpoz, ck : word;
  f : text;
begin
  assign (f, 'daugin.dat');
  reset (F);
  readln (f, sk);
  for ck := 1 to sk do
  begin
    readln (f, pgeil);
    val (pgeil, pgsk, pgpoz);
    pgeil := copy (pgeil, pgpoz, length (pgeil));
    nariai [ck].kof := pgsk;
    nariai [ck].n1 := pgeil [1];
    if length (pgeil) > 1 then nariai [ck].n2 := pgeil [2]
  end;
  close (F)
end;

begin
  skaitymas (sk, nariai);

end.