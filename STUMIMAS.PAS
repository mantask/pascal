program stumimas;
   var laukas: array [1..100,1..100] of boolean;
       kryptis: array [1..20] of char;
       simb: char;
       i, is: text;
       ilgis, il, ck, x, y: integer;
       saugykla: boolean;
BEGIN
    assign (is,'stum_in.dat');
    assign (i,'stum_out.dat');
    reset (is);
    rewrite (i);

    readln (is, ilgis);
    repeat
      il := il + 1;
      read(is,kryptis[il]);
    until eoln(is);
    readln(is);
    for y := 1 to ilgis do begin
      for x := 1 to ilgis do begin
        read(is, simb);
        if simb = '*' then laukas[x,y] := true;
      end;
      readln(is);
    end;


    FOR ck := 1 to il do begin
        case kryptis[ck] of

          'K': begin
                   for  y := 1 to ilgis do begin
                     saugykla := laukas [1,y];
                     for x := 1 to ilgis-1 do laukas [x,y] := laukas[x+1,y];
                     laukas[ilgis,y] := saugykla;
                   end;
               end;

          'D': begin
                   for y := 1 to ilgis do begin
                      saugykla := laukas [ilgis,y];
                      for x := ilgis downto 2 do laukas[x,y]:=laukas[x-1,y];
                      laukas[1,y]:=saugykla;
                   end;
               end;

          'V': begin
                  for x := 1 to ilgis do begin
                      saugykla := laukas[x,1];
                      for y := 1 to ilgis - 1 do laukas[x,y] := laukas[x,y+1];
                      laukas[x,ilgis] := saugykla;
                  end;
               end;

          'A': begin
                  for x := 1 to ilgis do begin
                     saugykla := laukas [x,ilgis];
                     for y := ilgis downto 2 do laukas[x,y] := laukas[x,y-1];
                     laukas[x,1] := saugykla;
                  end;
               end;

        end;
    END;

    for y := 1 to ilgis do begin
      for x := 1 to ilgis do begin
        if laukas[x,y] then write(i,'*') else write (i,'-');
      end;
      writeln(i);
    end;

    close(is);
    close(i);
END.