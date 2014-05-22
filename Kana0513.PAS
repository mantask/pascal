program JPM1_5_13;
   var fi, fo: text; { "file for input", "file for output" }
       ck, sum, { pagalbiniai kintamieji }
       suma, { suma, ismoketa sunui pask. metu diena }
       metai: integer; { sunaus amzius }
begin
   assign (fi, 'pinigai.txt'); assign (fo, 'ves.txt');
   reset (fi); rewrite (fo);
   readln (fi, metai);
   for ck := 1 to metai do
     begin
        readln (fi, sum);
        suma := suma + sum
     end;
   writeln (fo, suma);
   close (fi); close (fu)
end.