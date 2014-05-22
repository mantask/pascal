program pica;
var s1,s2,k1,k2,san1,san2:real;
begin
   writeln('Ivesk pirmos picos plota (cm)');
   read(s1);
   writeln('Ivesk antros picos plota (cm)');
   read(s2);
   writeln('Ivesk pirmos picos kaina');
   read(k1);
   writeln('Ivesk antros picos kaina');
   read(k2);
   san1:=k1/s1;
   san2:=k2/s2;
   if san1 > san2 then writeln('Antra pica santykinai pigesne')
   else writeln('Pirma pica santykinai pigesne');
end.