{ MK 2002 }
{ XII Olimpiados 227 uzd }
program skaiciai;

type
  Tsk = array [1 .. 10] of integer;
  Taib = set of 1 .. 10;

var
  ck, pg,
  suma, viso : integer;
  sk : Tsk;
  aib : Taib;
  eil : string;

procedure nuskaitymas (var suma, viso : integer; var sk : Tsk);
var
  eil, pgeil : string;
  ck, pg : integer;
begin
  Write ('Kokios sumos ieskome: ');
  readln (suma);
  write ('Iveskite sumuojamus skaicius:  ');
  readln (eil);
  ck := 1;
  while length (eil) > 0 do
  begin
    while eil [1] = ' ' do eil := copy (eil, 2, length (eil) - 1);
    pg := pos (' ', eil);
    if pg = 0 then
    begin
      pg := length (eil);
      pgeil := copy (eil, 1, pg);
    end
    else pgeil := copy (eil, 1, pg - 1);
    delete (eil, 1, pg);
    val (pgeil, sk [ck], pg);
    inc (ck)
  end;
  viso := ck - 1
end;

procedure paieska (aib : Taib; sum : Integer; var ats : Taib);
var
  ck : integer;
begin
  if ats <> [] then exit;
  if sum = suma then ats := aib
  else
  begin
    for ck := 1 to viso do
    if not (ck in aib) and (sum <= suma - sk [ck])
    then paieska (aib + [ck], sum + sk [ck], ats)
  end
end;

function IntToStr (I: integer): String;
var
  S: string;
begin
  Str(I, S);
  IntToStr := S;
end;


begin
  nuskaitymas (suma, viso, sk);

  aib := [];
  pg := 0;
  for ck := 1 to viso do
  if sk [ck] > 0 then pg := sk [ck] + pg;
  if pg >= suma then paieska ([], 0, aib);

  if aib = [] then writeln ('NERA')
  else
  begin
    eil := '';
    for ck := 1 to viso do
    if ck in aib then eil := eil + inttostr (sk [ck]) + ' + ';
    eil [length (eil) - 1] := '=';
    eil := eil + inttostr (suma);
    writeln (eil)
  end
end.