program generavimas;

type
  Tsk = set of 0 .. 9;
  tmas = array [1 .. 10] of -1 .. 9;

var
  sk1, sk2, sk3, sk4, sk5, sk6, sk7, sk8, sk9, sk10 : 0 .. 9;
  sk : Tsk;
  f : text;

procedure tikrink;

var
  m, mas : tmas;
  suma, ck : byte;
  ok : boolean;
{-----------------------------}
  procedure variant (gyl, ilg : byte; m : Tmas; var OKAY : boolean);
  var
    ck : byte;
    sk : real;

    function nebuvo (sk : byte) : boolean;
    var
      ok : boolean;
      ck : byte;
    begin
      ok := true;
      for ck := 1 to gyl do
      if sk = m [ck] then ok := false;
      nebuvo := ok
    end;

  begin
    if ok then exit
    else
    begin
      if gyl = ilg + 1 then
      begin
        sk := 0;
        for ck := 1 to ilg do
        sk := sk * 10 + m [ck];
        if frac (sk / ilg) = 0 then OKAY := true
      end
      else
      begin
        for ck := 1 to ilg do
        if nebuvo (mas [ck]) then
        begin
          m [gyl] := mas [ck];
          variant (gyl + 1, ilg, m, okay);
          m [gyl] := -1;
        end
      end
    end
  end;
{----------------------------------}
begin
  mas [1] := sk1;
  mas [2] := sk2;
  mas [3] := sk3;
  mas [4] := sk4;
  mas [5] := sk5;
  mas [6] := sk6;
  mas [7] := sk7;
  mas [8] := sk8;
  mas [9] := sk9;
  mas [10] := sk10;
{}if (mas [1] mod 2 <> 0) and (mas [2] mod 2 <> 0) then exit; { dalus is 2 }
{}if (mas [1] + mas [2] + mas [3]) mod 3 <> 0 then exit;       { dalus is 3 }
{}ok := false;                                      { dalus is 5 }
  for ck := 1 to 5 do
  if (mas [ck] = 0) or (mas [ck] = 5) then ok := true;
  if not ok then exit;
{}ok := false;                                      { dalus is 6 }
  suma := 0;
  for ck := 1 to 6 do
  suma := suma + mas [ck];
  if suma mod 3 = 0 then ok := true;
  if not ok then exit;
{}suma := 0;
  ok := false;
  for ck := 1 to 9 do
  suma := suma + mas [ck];
  if suma mod 9 = 0 then ok := true;
  if not ok then exit;
{}for ck := 1 to 10 do                              { dalus is 4, 7, 8 }
  m [ck] := -1;
  for ck := 4 to 8 do
  begin
    ok := false;
    variant (1, ck, m, ok);
    if not ok then break;
    if ck = 4
    then ck := 6
  end;
  { skaicius rastas ir irasomas i faila }
  for ck := 1 to 10 do write (f, mas [ck]);
  writeln (f);
  write ('.')
end;

begin
  assign (f, 'desimt.txt');
  rewrite (f);
  writeln;

  sk := [];

  for sk1 := 1 to 9 do
  begin
    sk := sk + [sk1];
    for sk2 := 0 to 9 do
    if not (sk2 in sk) then
    begin
      sk := sk + [sk2];
      for sk3 := 0 to 9 do
      if not (sk3 in sk) then
      begin
        sk := sk + [sk3];
        for sk4 := 0 to 9 do
        if not (sk4 in sk) then
        begin
          sk := sk + [sk4];
          for sk5 := 0 to 9 do
          if not (sk5 in sk) then
          begin
            sk := sk + [sk5];
            for sk6 := 0 to 9 do
            if not (sk6 in sk) then
            begin
              sk := sk + [sk6];
              for sk7 := 0 to 9 do
              if not (sk7 in sk) then
              begin
                sk := sk + [sk7];
                for sk8 := 0 to 9 do
                if not (sk8 in sk) then
                begin
                  sk := sk + [sk8];
                  for sk9 := 0 to 9 do
                  if not (sk9 in sk) then
                  begin
                    sk := sk + [sk9];
                    for sk10 := 0 to 9 do
                    if not (sk10 in sk) then
                    begin
                      sk := sk + [sk10];
                      tikrink;
                      sk := sk - [sk10];
                    end;
                    sk := sk - [sk9];
                  end;
                  sk := sk - [sk8];
                end;
                sk := sk - [sk7];
              end;
              sk := sk - [sk6];
            end;
            sk := sk - [sk5];
          end;
          sk := sk - [sk4];
        end;
        sk := sk - [sk3];
      end;
      sk := sk - [sk2];
    end;
    sk := sk - [sk1];
  end;
  close (f);
end.