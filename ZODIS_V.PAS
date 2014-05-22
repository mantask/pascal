program zodziai;
   var sk,ilgis: integer;
       pask, pirm: char;

   procedure f (zodis: string; gylis: integer; sk: integer);
   begin
         if gylis = ilgis then writeln(zodis)
             else begin inc (sk);f (zodis + pirm, gylis + 1, sk ) end;
               if gylis = ilgis then writeln (zodis);

{sk=pask}if zodis[gylis] = pask then  writeln (zodis);
    end;

begin
   ilgis := 4; pirm := '1'; pask := '3';
   sk:=0;
   f ('', 0, sk)
end.