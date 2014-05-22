{ Mantas Kanaporis           }
{ Vilniaus Zemynos gimnazija }
{ IVe klase                  }
{ ========================== }
{ III metu III skyriaus uzd. }
{ miestai                    }

Program MIESTAI;

type
  Tg = array [1 .. 50, 1 .. 50] of integer;

var
  g : Tg;
  v1, v2, ats : Integer;

procedure nuskaitymas (var v1, v2 : Integer; var g : Tg);
var
  f : Text;
  ckx, cky, pg : Integer;
begin
  for ckx := 1 to 50 do
  for cky := 1 to 50 do
  g [ckx, cky] := -1;

  assign (f, 'duomenys.dat');
  reset (f);
  readln (f, v1);
  readln (f, v2);
  while not eof (f) do
  begin
    readln (f, ckx, cky, pg);
    g [ckx, cky] := pg;
    g [cky, cky] := pg
  end;
  close (f)
end;

function rask : Integer;
var
  ats : array [1 .. 50] of integer;
  jau : array [1 .. 50] of boolean;
  v, ck : Integer;
begin
  fillchar (jau, sizeof (jau), 0);
  for ck := 1 to 50 do
  ats [ck] := -1;
  ats [v1] := 0;

  while not jau [v2] do
  begin
    v := 0;
    for ck := 1 to 50 do
    if not jau [ck] and (ats [ck] <> -1) and
       ((v = 0) or (ats [ck] < ats [v]))
    then v := ck;

    if v = 0 then break;

    jau [v] := true;
    for ck := 1 to 50 do
    if not jau [ck] and (g [v, ck] <> -1) and
       ((ats [ck] = -1) or (ats [ck] > ats [v] + g [v, ck]))
    then ats [ck] := ats [v] + g [v, ck]
  end;

  if ats [v2] = 0 then rask := -1
                  else rask := ats [v2]
end;

procedure rasymas (ats : Integer);
var
  f : Text;
begin
  assign (F, 'rezultat.dat');
  rewrite (f);
  writeln (f, ats);
  close (f)
end;

begin
  nuskaitymas (v1, v2, g);
  ats := rask;
  rasymas (ats)
end.
