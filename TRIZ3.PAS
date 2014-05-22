program trysTrizenkliai;
type
  Taibe = set of 1 .. 9;
var
  skt : Taibe;
  sand : longint;

function sandauga (sk1, sk2, sk3 : word) : longint;
  var pg : longint;
begin
  pg := sk1 * sk2;
  sandauga := pg * sk3);
end;

procedure tikrink (var skt : Taibe; sk1, sk2, sk3 : word; var sand : longint);
  var ck : 1 .. 9;
      pg : longint;
begin
  if skt = [] then
  begin
    if sandauga (sk1, sk2, sk3) > sand then
    begin
      sand := sandauga (sk1, sk2, sk3);
      writeln (sand, ' - ', sk1, ' ', sk2, ' ', sk3);
    end;
  end
  else begin
    if (sk1 div 100) = 0 then
    begin
      for ck := 1 to 6 do
      if ck in skt then
      begin
        skt := skt - [ck];
        tikrink (skt, sk1 * 10 + ck, sk2, sk3, sand);
        skt := skt + [ck];
      end
    end
    else begin
      if (sk2 div 100) = 0 then
      begin
        for ck := 1 to 6 do
        if ck in skt then
        begin
          skt := skt - [ck];
          tikrink (skt, sk1, sk2 * 10 + ck, sk3, sand);
          skt := skt + [ck];
        end
      end
      else begin
        if (sk3 div 100) = 0 then
        begin
          for ck := 1 to 6 do
          if ck in skt then
          begin
            skt := skt - [ck];
            tikrink (skt, sk1, sk2, sk3 * 10 + ck, sand);
            skt := skt + [ck];
          end
        end
      end {if sk2 jau suformuotas}
    end;{if sk1 jau suformuotas}
  end; {If dar ne visi sakiciai sudaryti}
end; {Procedure}

begin
  skt := [1, 2, 3, 4, 5, 6];
  sand := 0;
  tikrink (skt, 9, 8, 7, sand);
end.