{mirsta <2 arba >3 , 3 kaimynai - gimsta}
program gyvenimas;
  const ilg = 6;
  type Ttoras = array [0 .. ilg - 1, 0 .. ilg - 1] of boolean;
  var ck, kaim : byte;
      t, ts : Ttoras;
      x, y : byte;

  procedure skaitymas (var toras : Ttoras);
    var f : text;
        x,  y : byte;
        c : char;
  begin
    assign (f, 'POP.txt');
    reset (f);
    for y := 0 to ilg - 1 do
    begin
      for x := 0 to ilg - 1 do
      begin
        read (f, c);
        if c = 'X' then toras [x,y] := true else toras [x,y] := false;
      end;
      readln (f)
    end;
    close (F);
  end;


  procedure rasymas (toras : Ttoras);
    var x,  y : word;
  begin
    for y := 0 to ilg - 1 do
    begin
      for x := 0 to ilg - 1 do
      if toras [x, y] then write ('X') else write  ('-');
      writeln
    end;
  end;


begin
  skaitymas (ts);
  writeln ('<New>');
  rasymas (ts);
  t := ts;
  for ck := 1 to 3 do
  begin
    ts := t;
    for y := 0 to ilg - 1 do
    for x := 0 to ilg - 1 do
    begin
       kaim := 0;

       if ts [(x + 1) mod ilg,                           y] then inc (kaim);
       if ts [(x + 1) mod ilg,             (y + 1) mod ilg] then inc (kaim);
       if ts [(x + 1) mod ilg,       (y + ilg - 1) mod ilg] then inc (kaim);
       if ts [(x + ilg - 1) mod ilg,       (y + 1) mod ilg] then inc (kaim);
       if ts [(x + ilg - 1) mod ilg,                     y] then inc (Kaim);
       if ts [(x + ilg - 1) mod ilg, (y + ilg - 1) mod ilg] then inc (kaim);
       if ts [x,                     (y + ilg - 1) mod ilg] then inc (kaim);
       if ts [x,                           (y + 1) mod ilg] then inc (kaim);

       if (kaim = 3) and not (ts [x, y]) then t [x, y] := true;
       if ((kaim < 2) or (kaim > 3)) and (ts [x, y]) then t [x, y] := false;

    end;
  writeln ('<', ck, '>');
  rasymas (t);
  end;

end.