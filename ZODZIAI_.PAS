program zodziai;
  var ilgis: integer;
      pirm, pask: char;

    procedure F (zodis: string; sk: integer);
       var ck: char;
    begin
       if sk = ilgis then writeln (zodis)
       else for ck := pirm to pask do f (zodis + ck, sk + 1)
    end;


begin
   pirm := '1'; pask := '3'; ilgis := 3;
   f ('', 0)
end.