{ MK 2001 }
{ duotas zemelapis max 1000x1000, kuriam suzymtos salos, rasti salu skaiciu }
program salu_skaicius;

const
  bits : array [0 .. 7] of byte = (1, 2, 4, 8, 16, 32, 64, 128);

type
  Tsala = array [0 .. 124] of byte;  { 1000 div 8 }
  Tsalos = array [0 .. 999] of ^Tsala;

var
  f : text;
  ilgx, ilgy, { matrixos dydis }
  ckx, cky : word;
  sk : integer; { salu skaicius }
  c : char;
  salos : Tsalos;

procedure paruosk (var salos : Tsalos);
var
  ck : integer;
begin
  for ck := 0 to 999 do
  begin
    new (salos [ck]);
    fillchar (salos [ck]^, sizeof (salos [ck]^), 0);
  end;
end;

procedure valyk (var salos : Tsalos);
var
  ck : integer;
begin
  for ck := 0 to 999 do
  dispose (salos [ck])
end;

function rodyk (x, y : integer) : boolean; {true - sala}
begin
  rodyk := (salos [x]^[y div 8] and bits [y mod 8]) = bits [y mod 8]
end;

procedure priskirk (var salos : Tsalos; x, y : integer; sk : byte);
begin
  if sk = 1
  then salos [x]^ [y div 8] := salos [x]^ [y div 8] or bits [y mod 8]
  else salos [x]^ [y div 8] := salos [x]^ [y div 8] xor bits [y mod 8]
end;

procedure ieskok (var salos : Tsalos; x, y : integer);
begin
  if not rodyk (x, y) then exit
  else begin
    priskirk (salos, x, y, 0);
    if (x + 1 >= 0) and (x + 1 < ilgx) then ieskok (salos, x + 1, y);
    if (x - 1 >= 0) and (x - 1 < ilgx) then ieskok (salos, x - 1, y);
    if (y + 1 >= 0) and (y + 1 < ilgy) then ieskok (salos, x, y + 1);
    if (y - 1 >= 0) and (y - 1 < ilgy) then ieskok (salos, x, y - 1);
  end
end;

begin
  paruosk (salos);
  assign (f, 'sal.dat');
  reset (f);
  readln (f, ilgx, ilgy);
  for cky := 0 to ilgy - 1 do
  begin
    for ckx := 0 to ilgx - 1 do
    begin
      read (f, c);
      if c = '1' then priskirk (salos, ckx, cky, 1);
    end;
    readln (f)
  end;
  close (f);

  sk := 0;
  for ckx := 0 to ilgx - 1 do
  for cky := 0 to ilgy - 1 do
  if rodyk (ckx, cky) then
  begin
    inc (sk);
    ieskok (salos, ckx, cky);
  end;

  valyk (salos);
  assign (f, 'sal.rez');
  rewrite (f);
  write (f, sk);
  close (f);
end.