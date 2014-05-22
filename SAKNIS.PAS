program saknis;
    var sk, ck, ck_dg: integer;
        skaicius: longint;
        traukiasi: boolean;
        daug: array [1..80] of integer;
begin
    readln (sk,skaicius);
    repeat
        for ck := 2 to skaicius - 1 do
            if (skaicius mod ck = 0) and (not jau) then
               begin
                  inc(ck_dg);
                  daug[ck_dg] := ck;
                  skaicius := skaicius div ck;
                  break;
               end;

    until skaicius = 1;
    for ck := 1 to ck_dg do writeln(daug[ck])
end.