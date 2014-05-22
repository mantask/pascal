{ 704 is uzdavinyno. Turima kruvele degtuku ir imama ne daugiau kaip po 1/2
 kruveles. Kas paima paskutini degtuka, tas pralaimi. Perfect move}
program degtukai;
   var a, sk, ats: integer;
begin
  write ('Nurodykite kruveles dydi ');
  readln (sk);
  a := 1;
  repeat
    if sk = a then
         begin
            writeln ('Pralaimesi bet kuriuo atveju');
            break;
         end
    else if (a >= (sk div 2 + sk mod 2)) and (a < sk) then
          begin
             ats := sk - a;
             writeln ('Imti pirma karta reikia ', ats);
             break;
          end
   else a := a+a+1;
  until false;
  readln
end.