program metai;
uses crt;
var data,amzius,skirtumas:integer;t:char;
begin
    clrscr;
    writeln ('AMZIAUS SKAICIAVIMO PROGRAMA');
    writeln;
    writeln ('Iveskite gimimo metus');
    read (amzius);
    data:=2001;
    skirtumas:=data-amzius;
    if skirtumas<0 then
       begin
          begin
             writeln;
             writeln ('Atrodo Jusu laikas dar neatejo');
          end;
         if skirtumas=0 then
            begin
               writeln;
               writeln('Tu jau gimei ar dar tik gimsi?');
            end
       end
    else
      begin
       writeln;
       writeln ('Tu esi ',skirtumas,' metu amziaus.');
      end;
    readkey;
end.
