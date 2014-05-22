{MK 2001}
{722 is uzdavinyno}
PROGRAM skaiciai;
  const kiek = 6;
        skaic : array [1 .. kiek] of integer = (1, 2, 3, 4, 5, 6);
  var galutinis : integer;
      senas : string;

  procedure suma (sk : integer; ats : string; var senas : string); forward;
  procedure skirtumas (sk : integer; ats : string; var senas : string); forward;
  procedure dalyba (sk : integer; ats : string; var senas : string); forward;

  procedure daugyba (sk : integer; ats : string; var senas : string);
  begin
    if length (ats) = kiek - 1 then
    begin
      if (sk = galutinis) and (ats <> senas) then
      begin
        senas := ats;
        writeln ('((((', skaic [1], ats [1], skaic [2], ')', ats [2], skaic [3], ')', ats [3], skaic [4], ')',
                 ats [4], skaic [5], ')', ats [5], skaic [6], '=', galutinis)
      end
    end
    else begin
      ats := ats + '*';
      sk := sk * skaic [length (ats) + 1];
      daugyba (sk, ats, senas);
      dalyba (sk, ats, senas);
      suma (sk, ats, senas);
      skirtumas (sk, ats, senas);
    end;
  end;

  procedure Dalyba (sk : integer; ats : string; var senas : string);
  begin
    if length (ats) = kiek - 1 then
    begin
      if (sk = galutinis) and (ats <> senas) then
      begin
        senas := ats;
        writeln ('((((', skaic [1], ats [1], skaic [2], ')', ats [2], skaic [3], ')', ats [3], skaic [4], ')',
                 ats [4], skaic [5], ')', ats [5], skaic [6], '=', galutinis)
      end;
    end
    else begin
      ats := ats + '/';
      sk := sk div skaic [length (ats) + 1];
      dalyba (sk, ats, senas);
      daugyba (sk, ats, senas);
      suma (sk, ats, senas);
      skirtumas (sk, ats, senas);
    end;
  end;

  procedure suma (sk : integer; ats : string; var senas : string);
  begin
    if length (ats) = kiek - 1 then
    begin
      if (sk = galutinis) and (ats <> senas) then
      begin
        senas := ats;
        writeln ('((((', skaic [1], ats [1], skaic [2], ')', ats [2], skaic [3], ')', ats [3], skaic [4], ')',
                 ats [4], skaic [5], ')', ats [5], skaic [6], '=', galutinis)
      end;
    end
    else begin
      ats := ats + '+';
      sk := sk + skaic [length (ats) + 1];
      suma (sk, ats, senas);
      daugyba (sk, ats, senas);
      dalyba (sk, ats, senas);
      skirtumas (sk, ats, senas);
    end;
  end;

  procedure skirtumas (sk : integer; ats : string; var senas : string);
  begin
    if length (ats) = kiek - 1 then
    begin
      if (sk = galutinis) and (ats <> senas) then
      begin
        senas := ats;
        writeln ('((((', skaic [1], ats [1], skaic [2], ')', ats [2], skaic [3], ')', ats [3], skaic [4], ')',
                 ats [4], skaic [5], ')', ats [5], skaic [6], '=', galutinis)
      end;
    end
    else begin
      ats := ats + '-';
      sk := sk - skaic [length (ats) + 1];
      skirtumas (sk, ats, senas);
      daugyba (sk, ats, senas);
      dalyba (sk, ats, senas);
      suma (sk, ats, senas);
    end;
  end;

begin
  senas := '';
  galutinis := 35;
  writeln;
  writeln ('******SPRENDIMAS******');
  daugyba (skaic [1], '', senas);
  dalyba (skaic [1], '', senas);
  suma (skaic [1], '', senas);
  skirtumas (skaic [1], '', senas);
  writeln ('**********************');
end.