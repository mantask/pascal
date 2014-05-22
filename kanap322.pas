{
Mantas Kanaporis
Vilniaus Zemynos gimnazija
IVe klase
==========================
2.2 uzdavinys
}

Program KANAP22;

const
  koord : array [0 .. 3, 1 .. 2] of integer =
      ((0, -1), (1, 0), (0, 1), (-1, 0));

type
  Tmas = array [1 .. 1000, 1 .. 1000] of 0 .. 3;

var
  atgal, mas : Tmas;
  xx, yy : Integer;
  ok : boolean;

procedure nuskaitymas (var xx, yy : Integer; var mas : Tmas);
var
  f : Text;
  ck, x, y, x1, y1, x2, y2 : integer;
begin
  assign (f, 'duom.txt');
  reset (f);
  readln (f, xx, yy);
  for ck := 1 to xx * yy div 2 do
  begin
    readln (f, x1, y1, x2, y2);
    x := x1 - x2;
    y := y1 - y2;
    if x = 1 then mas [x2, y2] := 1
    else
    if x = -1 then mas [x2, y2] := 3
    else
    if y = 1 then mas [x2, y2] := 2
    else mas [x2, y2] := 0;
    mas [x1, y1] := (mas [x2, y2] + 2) mod 4
  end;
  close (f)
end;

procedure rask (var ok : boolean; var Atgal : Tmas);
var
  ilg : array [1 .. 1000, 1 .. 1000] of longint;
  eil : array [1 .. 50000, 1 .. 2] of 1 .. 1000;
  x, y, x1, y1, kr,
  gal, uod : Integer;
begin
  atgal [1 + koord [mas [1, 1], 1], 1 + koord [mas [1, 1], 2]] := (mas [1, 1] + 2) mod 4;
  fillchar (ilg, sizeof (ilg), 0);
  ilg [1, 1] := 1;
  eil [1, 1] := 1;
  eil [1, 2] := 1;
  gal := 1;
  uod := 2;
  while gal < uod do
  begin
    kr := mas [eil [gal, 1], eil [gal, 2]];
    x := eil [gal, 1] + koord [kr, 1];
    y := eil [gal, 2] + koord [kr, 2];
    x1 := x + koord [kr, 1];
    y1 := y + koord [kr, 2];
    if (x1 <= xx) and (x1 >= 1) and (y1 <= yy) and (y1 >= 1) and
       ((ilg [x1, y1] = 0) or (ilg [x1, y1] > ilg [eil [gal, 1], eil [gal, 2]] + 1)) then
    begin
      atgal [x1, y1] := (kr + 2) mod 4;
      atgal [x1 + koord [mas [x1, y1], 1], y1 + koord [mas [x1, y1], 2]] := mas [x1 + koord [mas [x1, y1], 1], y1 + koord [mas [x1, y1], 2]];
      ilg [x1, y1] := ilg [eil [gal, 1], eil [gal, 2]] + 1;
      ilg [x1 + koord [mas [x1, y1], 1], y1 + koord [mas [x1, y1], 2]] := ilg [x1, y1];
      eil [uod, 1] := x1;
      eil [uod, 2] := y1;
      inc (uod)
    end;
    x1 := x + koord [(kr + 1) mod 4, 1];
    y1 := y + koord [(kr + 1) mod 4, 2];
    if (x1 <= xx) and (x1 >= 1) and (y1 <= yy) and (y1 >= 1) and (mas [x1, y1] = (kr + 1) mod 4) and
       ((ilg [x1, y1] = 0) or (ilg [x1, y1] > ilg [eil [gal, 1], eil [gal, 2]] + 1)) then
    begin
      atgal [x1, y1] := (kr + 3) mod 4;
      atgal [x1 + koord [mas [x1, y1], 1], y1 + koord [mas [x1, y1], 2]] := mas [x1 + koord [mas [x1, y1], 1], y1 + koord [mas [x1, y1], 2]];
      ilg [x1, y1] := ilg [eil [gal, 1], eil [gal, 2]] + 1;
      ilg [x1 + koord [mas [x1, y1], 1], y1 + koord [mas [x1, y1], 2]] := ilg [x1, y1];
      eil [uod, 1] := x1;
      eil [uod, 2] := y1;
      inc (uod)
    end;
    x1 := x + koord [(kr + 3) mod 4, 1];
    y1 := y + koord [(kr + 3) mod 4, 2];
    if (x1 <= xx) and (x1 >= 1) and (y1 <= yy) and (y1 >= 1) and (mas [x1, y1] = (kr + 3) mod 4) and
       ((ilg [x1, y1] = 0) or (ilg [x1, y1] > ilg [eil [gal, 1], eil [gal, 2]] + 1)) then
    begin
      atgal [x1, y1] := (kr + 1) mod 4;
      atgal [x1 + koord [mas [x1, y1], 1], y1 + koord [mas [x1, y1], 2]] := mas [x1 + koord [mas [x1, y1], 1], y1 + koord [mas [x1, y1], 2]];
      ilg [x1, y1] := ilg [eil [gal, 1], eil [gal, 2]] + 1;
      ilg [x1 + koord [mas [x1, y1], 1], y1 + koord [mas [x1, y1], 2]] := ilg [x1, y1];
      eil [uod, 1] := x1;
      eil [uod, 2] := y1;
      inc (uod)
    end;
    inc (gal)
  end;
  if ilg [xx, yy] > 0 then ok := true
                      else ok := false
end;

procedure rasyk (var F : text; x, y : Integer; var atgal : Tmas; ras : boolean);
begin
  if not ((x = 1) and (y = 1))
  then rasyk (f, x + koord [atgal [x, y], 1],
                 y + koord [atgal [x, y], 2], atgal, not ras);
  if ras then writeln (f, x, ' ', y)
end;

procedure rasymas (ok : Boolean; var atgal : Tmas);
var
  f : text;
begin
  assign (f, 'rez.txt');
  rewrite (f);
  if ok then rasyk (f, xx, yy, atgal, false)
        else writeln (f, 'NEEGZISTUOJA');
  close (f)
end;

begin
  nuskaitymas (xx, yy, mas);
  rask (ok, atgal);
  rasymas (ok, atgal)
end.
