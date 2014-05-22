program pirminiai;
uses crt;
var sk, dal, dal1, rez: integer;
    pirm: boolean;
begin
   clrscr;
   read (sk);
   pirm:=true;
   dal:=2;
   while (rez/dal<>0) or (sk/dal<>0) do
    begin
     for dal:=2 to (sk-1) do
       begin
          if sk mod dal = 0 then
            begin
               pirm:=false;
               rez:=sk div dal;
               for dal:=2 to (rez-1) do
                 if rez mod dal = 0 then
                 else writeln(rez/dal);
            end;
       end;
     end;
   if pirm=true then writeln ('Ivedete  pirmini skaiciu')
   else writeln('skaicius nepirminis');
end.