{ MK 2001 }
{ Europe Article Numeration - bruksninis kodas, sutinkamas ant prekiu }
{ skaiciu suma turi dalintis is 10, paskutinis skaicius yra kontrolinis,
  o pirmi du - salies kodas. Lietuvos kodas yra 97 }
{ etikete piesia i langa (10, 10, 113, 69) }
program EAN;

Uses
  graph;

Type
  Tskaicius = array [1 .. 13] of 0 .. 9;

Const
  eil : string = '9789955081883';        { prekes kodas, modifikuoti cia }
  Code : array [0 .. 9, 1 .. 3, 1 .. 7] of 0 .. 1 =
       (((0,0,0,1,1,0,1), (0,1,0,0,1,1,1), (1,1,1,0,0,1,0)),
        ((0,0,1,1,0,0,1), (0,1,1,0,0,1,1), (1,1,0,0,1,1,0)),
        ((0,0,1,0,0,1,1), (0,0,1,1,0,1,1), (1,1,0,1,1,0,0)),
        ((0,1,1,1,1,0,1), (0,1,0,0,0,0,1), (1,0,0,0,0,1,0)),
        ((0,1,0,0,0,1,1), (0,0,1,1,1,0,1), (1,0,1,1,1,0,0)),
        ((0,1,1,0,0,0,1), (0,1,1,1,0,0,1), (1,0,0,1,1,1,0)),
        ((0,1,0,1,1,1,1), (0,0,0,0,1,0,1), (1,0,1,0,0,0,0)),
        ((0,1,1,1,0,1,1), (0,0,1,0,0,0,1), (1,0,0,0,1,0,0)),
        ((0,1,1,0,1,1,1), (0,0,0,1,0,0,1), (1,0,0,1,0,0,0)),
        ((0,0,0,1,0,1,1), (0,0,1,0,1,1,1), (1,1,1,0,1,0,0)));
  grupe2 : array [0 .. 9, 2 .. 7] of 1 .. 2 =
        ((1, 1, 1, 1, 1, 1),
         (1, 1, 2, 1, 2, 2),
         (1, 1, 2, 2, 1, 2),
         (1, 1, 2, 2, 2, 1),
         (1, 2, 1, 1, 2, 2),
         (1, 2, 2, 1, 1, 2),
         (1, 2, 2, 2, 1, 1),
         (1, 2, 1, 2, 1, 2),
         (1, 2, 1, 2, 2, 1),
         (1, 2, 2, 1, 2, 1));
  ilg = 50;

Var
  gm, gd : integer;
  skaic : Tskaicius;

procedure Piesk (skaic : Tskaicius);
  var ck, ck1 : byte;
      X, Y : word;
      pg : string;
begin
  Y := 10; X := 10;
  str (skaic [1], pg);
  outTextXY (x, y + ilg + 3, pg);
  inc (x, 7);
  line (x, y, x, y + ilg + 7);
  line (x + 2, y, x + 2, y + ilg + 7);
  inc (x, 3);
  for ck := 2 to 7 do
  begin
    str (skaic [ck], pg);
    outTextXY (x, y + ilg + 3, pg);
    for ck1 := 1 to 7 do
    begin
      if code [skaic [ck], grupe2 [skaic [1], ck], ck1] = 1
      then line (x, y, x, y + ilg);
      inc (x);
    end;
  end;
  line (x + 1, y, x + 1, y + ilg + 7);
  line (x + 3, y, x + 3, y + ilg + 7);
  inc (x, 5);
  for ck := 8 to 13 do
  begin
    str (skaic [ck], pg);
    outTextXY (x, y + ilg + 3, pg);
    for ck1 := 1 to 7 do
    begin
      if code [skaic [ck], 3, ck1] = 1
      then line (x, y, x, y + ilg);
      inc (x);
    end;
  end;
  line (x, y, x, y + ilg + 7);
  line (x + 2, y, x + 2, y + ilg + 7);
end;

procedure Priskirk (var skaic : Tskaicius; eil : string);
  var ck : byte;
      pg, kodas : integer;
begin
  for ck := 1 to 13 do
  begin
    val (eil [ck], pg, kodas);
    skaic [ck] := pg;
  end;
end;

{yra visai ne taip}
Function teisingas (skaic : Tskaicius) : boolean;
  var ck : byte;
      suma : word;
begin
  suma := skaic [1] + skaic [13];
  for ck := 2 to 12 do
  suma := suma + 3 * skaic [ck];
  if (suma mod 10 = 0) then teisingas := true
                       else teisingas := false;
end;

begin
  initgraph (gm, gd, '');

  priskirk (skaic, eil);
  setcolor (7);
  piesk (skaic);

  repeat until port [$60] = 1;
  closegraph;
end.
