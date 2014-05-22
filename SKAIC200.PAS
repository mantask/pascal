{pabandysiu padaryti su binariniu medziu}
program Skaiciai_2001;
  type Pskaicius = ^Tskaicius;
       Tskaicius = record
         eil : string;
         kr, ds : Pskaicius;
       end;
  var skaic : Pskaicius;
      f, f1, f2, f3, f4 : text;

  function daugiau (pirma, antra : string) : boolean;
    var ck : byte;
        jau : boolean;
  begin
    jau := false;
    ck := 1;
    while not jau do
    begin
      if length (pirma) < ck then begin daugiau := false; exit end;
      if length (antra) < ck then begin daugiau := true; exit end;
      if pirma [ck] = antra [ck] then inc (ck)
      else begin
        if pirma [ck] > antra [ck] then
        begin
          daugiau := true;
          jau := true;
        end
        else begin
          daugiau := false;
          jau := true;
        end
      end;{if lygu}
    end; {while}
  end; {function}

  procedure Prijunk (var skaic : Pskaicius; Eil : string);
    var T, P : Pskaicius;
  begin
    P := skaic;
    while P <> nil do
    begin
      T := P;
      if daugiau (eil, P^.eil) then p := p^.ds
                               else p := p^.kr;
    end;
    new (P);
    P^.eil := eil;
    P^.kr := nil;
    P^.ds := nil;
    if skaic = nil
      then skaic := P
      else if daugiau (eil, T^.eil) then T^.ds := P
                                    else T^.kr := P;
  end;

  procedure R1 (eil : string);
  begin
    writeln (f1, eil);
  end;
  procedure R2 (eil : string);
  begin
    writeln (f2, eil);
  end;
  procedure R3 (eil : string);
  begin
    writeln (f3, eil);
  end;
  procedure R4 (eil : string);
  begin
    writeln (f4, eil);
  end;
  procedure R (eil : string);
  begin
    writeln (f, eil);
  end;


  procedure paruosk;
    var ck : word;
        pg : byte;
        eil : string;
        c : char;
  begin
    for ck := 1 to 2001 do
    begin
      eil := '';
    {tuktanciai}
      pg := ck div 1000;
      if pg > 0 then
      begin
        case pg of
          2: eil := 'du tukstanciai ';
          1: eil := 'tukstantis ';
        end {case}
      end; {if 1000}
    {simtai}
      pg := ck mod 1000 div 100;
      if pg > 0 then
      begin
        case pg of
          1: eil := eil + 'simtas ';
          2: eil := eil + 'du ';
          3: eil := eil + 'trys ';
          4: eil := eil + 'keturi ';
          5: eil := eil + 'penki ';
          6: eil := eil + 'sesi ';
          7: eil := eil + 'septyni ';
          8: eil := eil + 'astuoni ';
          9: eil := eil + 'devyni ';
        end; {case}
        if pg <> 1 then eil := eil + 'simtai ';
      end; {if 100}
    {desimtys}
      pg := ck mod 100 div 10;
      if pg <> 0 then
      begin
        if pg > 1 then
        case pg of
         2: eil := eil + 'dvidesimt ';
         3: eil := eil + 'trisdesimt ';
         4: eil := eil + 'keturiasdesimt ';
         5: eil := eil + 'penkiasdesimt ';
         6: eil := eil + 'sesiasdesimt ';
         7: eil := eil + 'septyniasdesimt ';
         8: eil := eil + 'astuoniasdesimt ';
         9: eil := eil + 'devyniasdesimt ';
        end {case}
        {pg = 1}
        else begin
          pg := ck mod 100;
          case pg of
            10: eil := eil + 'desimt';
            11: eil := eil + 'vienuolika';
            12: eil := eil + 'dvylika';
            13: eil := eil + 'trylika';
            14: eil := eil + 'keturiolika';
            15: eil := eil + 'penkiolika';
            16: eil := eil + 'sesiolika';
            17: eil := eil + 'septyniolika';
            18: eil := eil + 'astuoniolika';
            19: eil := eil + 'devyniolika';
          end; {case}
        end;{else 10 .. 19}
      end; {if 10}
    {vienetai}
      pg := ck mod 10;
      if (pg <> 0) and (ck mod 100 div 10 <> 1) then
      begin
        case pg of
          1: eil := eil + 'vienas';
          2: eil := eil + 'du';
          3: eil := eil + 'trys';
          4: eil := eil + 'keturi';
          5: eil := eil + 'penki';
          6: eil := eil + 'sesi';
          7: eil := eil + 'septyni';
          8: eil := eil + 'astuoni';
          9: eil := eil + 'devyni';
        end; {case}
      end; {if 1}
{      prijunk (skaic, eil);}
      c := eil [1];
      if c in ['a', 'd', 'k'] then r1 (eil);
      if (c in ['p', 's', 'v']) or ((c = 't') and (eil [2] = 'r')) then r2 (eil);
      if (c = 't') and (eil [2] = 'u') then
      begin
        c := eil [12];
        if (c in ['a', 'd', 'k']) or (length (eil) = 11) then r3 (eil);
        if c in ['p', 's', 'v', 't'] then r4 (eil);
      end; {jei 'tukstantis'}
      r (eil);
    end; {for}
  end; {Procedure}

  procedure rasyk (var F : text; skaic : Pskaicius);
  begin
    if skaic <> nil then
    begin
      rasyk (f, skaic^.kr);
      writeln (f, skaic^.eil);
      rasyk (f, skaic^.ds);
    end
  end;

  procedure Skaityk (var f : text);
    var eil : string;
  begin
    while not eof (f) do
    begin
      readln (f, eil);
      prijunk (skaic, eil);
    end;
  end;

begin
  assign (f, 'skaic.txt');
  assign (f1, 'skaic1.txt');
  assign (f2, 'skaic2.txt');
  assign (f3, 'skaic3.txt');
  assign (f4, 'skaic4.txt');
  reset (f4);
{  rewrite (f);
  rewrite (f1);
  rewrite (f2);
  rewrite (f3);
  rewrite (f4);}
  skaityk (f4);
  close (f4);
  rewrite (f4);
  rasyk (f4, skaic);
  close (f4);
{  close (f);
  close (f1);
  close (f2);
  close (f3);
  close (f4);}
end.