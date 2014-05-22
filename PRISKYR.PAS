{ MK 2002 }
{ 12 Olimpiados III etapo 1 dalis }
program Priskyrimo_sakiniai;

type
  Top = char; { operaciju tipas }
  Tvar = 'a' .. 'z'; { kintamojo tipas }
  Tsak =
  record
    v1, v2 : Tvar;
    op : Top;
    num, val : integer;
  end;
  Tmas = array [1 .. 22] of Tsak;
  Taib = set of 1 .. 22;

var
  viso, sk : integer;
  mas : Tmas;
  {-----Pagalbiniai-----}
  f : text;
  pg, ck : integer;
  pgeil : string;
  ok : boolean;

Function galima (sak : Tsak; var sk : integer) : boolean;
var
  pg : boolean;
begin
  pg := true;
  case sak.op of
    '+' : sk := sk - sak.val;
    '-' : sk := sk + sak.val;
    '*' : if (sak.val = 0) or (sk mod sak.val <> 0)
          then pg := false
          else sk := sk div sak.val;
    '/' : sk := sk * sak.val;
  end;
  galima := pg
end;

{ is karto pasalina nieko nelemiancius sakinius }
Procedure Salinimas (var viso : integer; var mas : tmas);
var
  pg : Tvar;
  ck, ck1 : integer;
begin
  pg := mas [viso].v2;
  for ck := viso - 1 downto 1 do
  if mas [ck].v1 <> pg then
  begin
    for ck1 := ck to viso - 1 do
    mas [ck1] := mas [ck1 + 1];
    inc (ck);
    dec (viso);
  end;
end;

procedure ieskojimas (var ok : boolean; sk : integer; v : Tvar;
                      viso : integer; mas : tmas; a : Taib);
var
  pgsk, ck, ck1 : integer;
  pg : Tsak;
begin
  if sk = 1 then
  begin
    for ck := 1 to 22 do
    if ck in a then writeln (ck);
    ok := false
  end
  else
  begin
    for ck := 1 to viso do
    if mas [ck].v1 = v then
    begin
      pg := mas [ck];
      for ck1 := ck to viso - 1 do
      mas [ck1] := mas [ck1 + 1];
      pgsk := sk;
      if ok and galima (pg, sk)
      then IESKOJIMAS (ok, sk, pg.v2, viso - 1, mas, a + [pg.num]);
      sk := pgsk;
      for ck1 := viso downto ck + 1 do
      mas [ck1] := mas [ck1 - 1];
      mas [ck] := pg
    end;
  end;
end;

begin
  assign (f, 'sakiniai.dat');
  reset (f);
  readln (f, sk);
  readln (f, viso);
  for ck := 1 to viso do
  begin
    readln (f, pgeil);
    mas [ck].num := ck;
    mas [ck].v1 := pgeil [1];
    mas [ck].v2 := pgeil [4];
    mas [ck].op := pgeil [5];
    pgeil := copy (pgeil, 6, length (pgeil) - 6);
    val (pgeil, mas [ck].val, pg)
  end;
  close (F);

  Salinimas (viso, mas);
  ok := true;
  if galima (mas [viso], sk) then
  begin
    IESKOJIMAS (ok, sk, mas [viso].v2, viso - 1, mas, [viso]);
    if ok then writeln ('Negalima')
  end
  else writeln ('Negalima');
  writeln ('---')
end.
