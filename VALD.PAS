program valdoves;

  uses crt;

  type Tlenta = array [1 .. 10, 1 .. 10] of boolean;
       Tseni = array [0 .. 10] of record
                                    x, y : byte
                                  end;
  var f : text;
      lenta : Tlenta; {sachmatu lenta}
      ckX, ckY, {ciklo kintamieji}
      vvald, {visu valdoviu skaicius}
      ilg : byte;{krastines ilgis}
      taip : boolean; {ar galima su valdovemis uzpildyti lauka?}
      seni : Tseni; {ankstesniu valdoviu pozicijos, kurias reikia perzymeti}

  procedure valyk (x, y : byte; var lenta : Tlenta);
    var ckX, ckY : byte;
  begin
    if (x = 0) and (y = 0) then exit;
    for ckX := 1 to ilg do
    lenta [ckX, y] := false;
    for ckY := 1 to ilg do
    lenta [x, ckY] := false;
    ckX := x; ckY := Y;
    while (ckx <> 1) and (ckY <> 1) do
    begin
      dec (ckX);
      dec (ckY);
      lenta [ckX, ckY] := false;
    end;
    ckX := x; ckY := Y;
    while (ckx <> ilg) and (ckY <> ilg) do
    begin
      inc (ckX);
      inc (ckY);
      lenta [ckX, ckY] := false;
    end;
    ckX := x; ckY := Y;
    while (ckx <> 1) and (ckY <> ilg) do
    begin
      dec (ckX);
      inc (ckY);
      lenta [ckX, ckY] := false;
    end;
    ckX := x; ckY := Y;
    while (ckx <> ilg) and (ckY <> 1) do
    begin
      inc (ckX);
      dec (ckY);
      lenta [ckX, ckY] := false;
    end;
  end;

  procedure zymek (x, y : byte; var lenta : Tlenta);
    var ckX, ckY : byte;
  begin
    if (x = 0) and (y = 0) then exit;
    for ckX := 1 to ilg do
    lenta [ckX, y] := true;
    for ckY := 1 to ilg do
    lenta [x, ckY] := true;
    ckX := x; ckY := Y;
    while (ckx <> 1) and (ckY <> 1) do
    begin
      dec (ckX);
      dec (ckY);
      lenta [ckX, ckY] := true;
    end;
    ckX := x; ckY := Y;
    while (ckx <> ilg) and (ckY <> ilg) do
    begin
      inc (ckX);
      inc (ckY);
      lenta [ckX, ckY] := true;
    end;
    ckX := x; ckY := Y;
    while (ckx <> 1) and (ckY <> ilg) do
    begin
      dec (ckX);
      inc (ckY);
      lenta [ckX, ckY] := true;
    end;
    ckX := x; ckY := Y;
    while (ckx <> ilg) and (ckY <> 1) do
    begin
      inc (ckX);
      dec (ckY);
      lenta [ckX, ckY] := true;
    end;
  end;

  function pilnas (lenta : Tlenta) : boolean;
    var ckX, ckY : byte;
  begin
    pilnas := true;
    for ckY := 1 to ilg do
    for ckX := 1 to ilg do
    if not lenta [ckX, ckY] then
    begin
      pilnas := false;
      break;
    end
  end;

  procedure galima (vald : byte; var lenta : Tlenta; var taip : boolean; seni : Tseni);
    var ck, ckX, ckY : byte;
  begin
    for ckY := 1 to ilg do
    for ckX := 1 to ilg do
    begin
      zymek (ckX, ckY, lenta);
      seni [vvald - vald + 1].x := ckX;
      seni [vvald - vald + 1].y := ckY;
      if vald > 1 then galima (vald - 1, lenta, taip, seni);
      seni [vvald - vald + 1].x := 0;
      seni [vvald - vald + 1].y := 0;
      if pilnas (lenta) then
      begin
        taip := true;
        if vald = 1 then
        begin
          writeln ('**** Galima ****');
          for ck := 1 to vvald - vald do
          writeln (seni [ck].x, ' ', seni [ck].y);
          writeln (ckx, ' ', ckY);
        end;
        exit
      end;
      valyk (ckx, cky, lenta);
      for ck := 1 to vvald - vald do
      zymek (seni [ck].x, seni [ck].y, lenta);
    end;
  end;

begin
  assign (f, 'vald.txt');
  reset (f);
  readln (f, vvald);
  readln (f, ilg);
  close (f);

  clrscr;
  writeln (ilg, 'x', ilg, ' lenta su ', vvald, ' valdovemis');
  writeln ('****************');
  writeln ('Skaiciuojama ....');
  taip := false;
  galima (vvald, lenta, taip, seni);
  if taip then writeln ('****************')
          else writeln ('Negalima');


  sound (1000);
  repeat until port [$60] = 1;
  nosound;
end.