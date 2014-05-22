program DAUG;
uses crt;
var sk,dal,dal1: integer;
    rez:real;
begin
   clrscr;
   read (sk);
   for dal := 2 to (sk-1) do
    begin
       if sk mod dal = 0 then writeln(dal);
       if sk mod dal = 0 then
          begin
             rez:= sk / dal;
             for dal1 := 2 to (rez-1) do
                 begin
                    if rez mod dal1 = 0 then
                           begin
                              rez:=rez/dal1;
                              writeln (rez);
                           end;
               end;
          end;
    end;
end.
