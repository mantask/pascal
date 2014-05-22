program kubeliai;
uses crt;
var pirm, antr, trec, vid, liek, didz, maz: integer;
Label 1;
begin                              {klaida su 4 6 5}
   clrscr;
   readLn(pirm,antr,trec);
   vid:=(pirm+antr+trec) div 3;
   liek:=(pirm+antr+trec) mod 3;
   while ((pirm<>vid+1)or(pirm<>vid))and((antr<>vid+1)or(antr<>vid))and(trec<>vid) do begin
     if pirm=antr then begin antr:=antr-1; trec:=trec+1; end
              else if antr=trec then begin antr:=antr-1; pirm:=pirm+1; end
                 else begin
        if (pirm>antr) and (pirm>trec) then didz:=1 else
                             if antr>trec then didz:=2 else didz:=3;
        if (pirm<antr) and (pirm<trec) then maz:=1 else
                             if antr<trec then maz:=2 else maz:=3;
        case didz of
           1: if pirm>vid+1 then begin pirm:=pirm-1; antr:=antr+1; end;
           2: if antr>vid+1 then begin antr:=antr-1;
                                   if maz=1 then pirm:=pirm+1;
                                   if maz=3 then trec:=trec+1; end;
           3: if trec>vid then begin trec:=trec-1; antr:=antr+1; end;
        end;
             end;
        writeln(pirm,' ',antr,' ',trec);
   end;
end.