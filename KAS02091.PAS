program devynzenkliai;

var
  viso,
  ck1, ck2, ck3, ck4, ck5, ck6, ck7, ck8, ck9 : integer;
  aib : set of 1 .. 9;
  sk : longint;
  F : Text;

function ok (sk : Longint) : boolean;
var
  mas : array [0 .. 10] of boolean;
  pg : integer;
begin
  fillchar (mas, sizeof (mas), 0);
  while sk > 0 do
  begin
    pg := sk mod 10;
    if (pg = 0) or mas [pg] then
    begin
      ok := false;
      exit
    end
    else mas [pg] := true;
    sk := sk div 10
  end;
  ok := true
end;

begin
  aib := [1 .. 9];
  viso := 0;
  assign (f, 'kas02091.txt');
  rewrite (f);
  for ck1 := 1 to 9 do
  begin
    aib := aib - [ck1];
    sk := ck1;
    for ck2 := 1 to 9 do
    if ck2 in aib then
    begin
      aib := aib - [ck2];
      sk := sk * 10 + ck2;
      for ck3 := 1 to 9 do
      if ck3 in aib then
      begin
        aib := aib - [ck3];
        sk := sk * 10 + ck3;
        for ck4 := 1 to 9 do
        if ck4 in aib then
        begin
          aib := aib - [ck4];
          sk := sk * 10 + ck4;
          for ck5 := 1 to 9 do
          if ck5 in aib then
          begin
            aib := aib - [ck5];
            sk := sk * 10 + ck5;
            for ck6 := 1 to 9 do
            if ck6 in aib then
            begin
              aib := aib - [ck6];
              sk := sk * 10 + ck6;
              for ck7 := 1 to 9 do
              if ck7 in aib then
              begin
                aib := aib - [ck7];
                sk := sk * 10 + ck7;
                for ck8 := 1 to 9 do
                if ck8 in aib then
                begin
                  aib := aib - [ck8];
                  sk := sk * 10 + ck8;
                  for ck9 := 1 to 9 do
                  if ck9 in aib then
                  begin
                    sk := sk * 10 + ck9;
                    if (sk mod 8 = 0) and ok (sk div 8) then
                    begin
                      inc (viso);
                      writeln (f, viso :3, '. ', sk, ' : 8 = ', sk div 8);
                      write ('.')
                    end;
                    sk := sk div 10;
                  end;
                  sk := sk div 10;
                  aib := aib + [ck8]
                end;
                sk := sk div 10;
                aib := aib + [ck7]
              end;
              sk := sk div 10;
              aib := aib + [ck6]
            end;
            sk := sk div 10;
            aib := aib + [ck5]
          end;
          sk := sk div 10;
          aib := aib + [ck4]
        end;
        sk := sk div 10;
        aib := aib + [ck3]
      end;
      sk := sk div 10;
      aib := aib + [ck2]
    end;
    aib := aib + [ck1]
  end;
  close (f)
end.