program laikas;
var val,min,sek:integer;
begin
   writeln('Ivesk valandas');
   read(val);
   writeln('Ivesk minutes');
   read(min);
   writeln('Ivesk sekundes');
   read(sek);
   if (val >= 0) and (val <= 23)  and (min >= 0) and (min <= 59) and (sek >= 0) and (sek <= 59) then
   writeln('Ivedete teisingai')
   else writeln('Neteisingai');
end.
