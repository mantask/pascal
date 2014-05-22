program labirintas;
   uses crt;
   type koord = array [1..5,1..5] of boolean;
   var lab,ats: koord;
       f: text;
       ilgis, ck1, ck2: integer;
       c: char;

   procedure veiksmai(x,y: integer; var ats:koord);
      var ck1, ck2: integer;
   begin
   if (lab [x,y]) and (not ats [x,y]) then
   begin
      ats [x,y] := true;
      if (ats[5,5]) then
         begin
             for ck1:=1 to ilgis do
                begin
                  for ck2 := 1 to ilgis do
                    if ats [ck1,ck2] then write('*') else write (' ');
                    writeln
                end;
 {          readkey; clrscr;}
         end
       else begin
                  if (y+1) in [1..5] then veiksmai (x,y+1, ats);
                  if (x+1) in [1..5] then veiksmai (x+1,y, ats);
                  if (x-1) in [1..5] then veiksmai (x-1,y, ats);
                  if (y-1) in [1..5] then veiksmai (x,y-1, ats)

              end;
        ats [x,y]  := false
      end
   end;

begin
  clrscr;
   assign (f, 't.txt');
   reset (f);
   readln(f,ilgis);
   for ck1:=1 to ilgis do
    begin
     for ck2 := 1 to ilgis do
       begin
          read (f,c);
          if c = '.' then lab[ck1,ck2]:=true else lab[ck1,ck2]:=false
       end;
     readln(f);
    end;
   close (f);
   veiksmai (1,1, ats)
end.