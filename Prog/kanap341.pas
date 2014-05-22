{ Mantas Kanaporis           }
{ Vilniaus Zemynos gimnazija }
{ IVe klase                  }
{ ========================== }
{ III metu 4 uzduotis        }

Program REISKINYS;

type
  Tmas = array [1 .. 1000] of integer;
  Tsk = array [1 .. 1000] of longint;

var
  mas : Tmas;
  sk : Tsk;
  ilg : Integer;

procedure nuskaitymas (var ilg : Integer; var mas : Tmas; var sk : Tsk);
var
  f : Text;
  viso : integer;
  pg : longint;
  c : char;
  min : boolean;
begin
  assign (f, 'duom.txt');
  reset (f);
  viso := 0;
  pg := 0;
  ilg := 0;
  min := false;
  while not eoln (f) do
  begin
    read (f, c);
    if (ord (c) >= 48) and (ord (c) <= 58)
    then pg := pg * 10 + ord (c) - ord ('0')
    else
    begin
      if pg <> 0 then
      begin
        inc (viso);
        if min then
        begin
          sk [viso] := -pg;
          min := false
        end
        else sk [viso] := pg;
        pg := 0;
        inc (ilg);
        mas [ilg] := viso
      end;
      inc (ilg);
      case c of
        '(' : mas [ilg] := -1;
        ')' : mas [ilg] := -2;
        '*' : mas [ilg] := -3;
        '/' : mas [ilg] := -4;
        '\' : mas [ilg] := -5;
        '+' : mas [ilg] := -6;
        '-' : if (ilg = 1) or (mas [ilg - 1] = -1) then
              begin
                dec (ilg);
                min := true
              end
              else mas [ilg] := -7
      end
    end
  end;
  if pg <> 0 then
  begin
    inc (viso);
    if min then sk [viso] := -pg
           else sk [viso] := pg;
    inc (ilg);
    mas [ilg] := viso
  end;
  close (f)
end;

procedure rask (nuo, iki : integer; var mas : Tmas; var sk : Tsk);
var
  kiek, ck, ck1, ck2 : Integer;
begin
  { sutvarkom skliaustelius }
  for ck1 := nuo to iki do
  if mas [ck1] = -1 then
  begin
    kiek := 1;
    ck2 := ck1;
    while kiek <> 0 do
    begin
      inc (ck2);
      if mas [ck2] = -1 then inc (kiek)
      else
      if mas [ck2] = -2 then dec (kiek)
    end;
    rask (ck1 + 1, ck2 - 1, mas, sk);
    mas [ck1] := 0;
    mas [ck2] := 0;
    break
  end;
  { sutvarkom daugyba ir dalyba }
  for ck := nuo to iki do
  if (mas [ck] <> 0) and ((mas [ck] = -3) or
     (mas [ck] = -4) or (mas [ck] = -5)) then
  begin
    ck1 := ck - 1;
    ck2 := ck + 1;
    while mas [ck1] = 0 do dec (ck1);
    while mas [ck2] = 0 do inc (ck2);
    case mas [ck] of
      -3 : sk [mas [ck1]] := sk [mas [ck1]] * sk [mas [ck2]];
      -4 : sk [mas [ck1]] := sk [mas [ck1]] div sk [mas [ck2]];
      -5 : sk [mas [ck1]] := sk [mas [ck1]] mod sk [mas [ck2]]
    end;
    mas [ck] := 0;
    mas [ck2] := 0
  end;
  { sutvarkom sudeti ir atimti }
  for ck := nuo to iki do
  if (mas [ck] <> 0) and ((mas [ck] = -6) or (mas [ck] = -7)) then
  begin
    ck1 := ck - 1;
    ck2 := ck + 1;
    while mas [ck1] = 0 do dec (ck1);
    while mas [ck2] = 0 do inc (ck2);
    case mas [ck] of
      -6 : sk [mas [ck1]] := sk [mas [ck1]] + sk [mas [ck2]];
      -7 : sk [mas [ck1]] := sk [mas [ck1]] - sk [mas [ck2]]
    end;
    mas [ck] := 0;
    mas [ck2] := 0
  end
end;

procedure rasymas (var mas : Tmas; var sk : Tsk);
var
  ck : Integer;
  f : text;
begin
  ck := 1;
  while mas [ck] = 0 do inc (ck);
  assign (f, 'rez.txt');
  rewrite (f);
  writeln (F, sk [mas [ck]]);
  close (f)
end;

begin
  nuskaitymas (ilg, mas, sk);
  rask (1, ilg, mas, sk);
  rasymas (mas, sk)
end.
