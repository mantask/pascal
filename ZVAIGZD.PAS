program zvaigzdutes;
uses crt, graph;

var il,ck,kr,x,y,sk,krastine:integer;
    antras:boolean;

    gd, gm : integer;

function simb(a:integer):char;
   var dalm:integer;
       pirminis: boolean;
   begin
       pirminis:=true;
       for dalm:= 2 to a-1 do begin
          if a mod dalm = 0 then pirminis:=false;
       end;
       if pirminis then simb:='*' else simb:='-';
   end;

begin
   clrscr;
   kr:=1;il:=0;sk:=0;
   x:=3; y:=3;
   repeat
      read(krastine);
   until krastine mod 2=1;

   gd := 0;
   initgraph (gd, gm, '');

   REPEAT
     if antras then il:=il-1 else il:=il+1;
     for ck:=1 to il do begin
         SK:=sk+1;
         if ck<>1 then begin
                    if kr=1 then begin x:=x+1; y:=y-1; end;
                    if kr=2 then begin x:=x-1; y:=y+1; end; end;
        { gotoxy(x,y);
         write(simb(sk));}
         if simb(sk) = '*' then putpixel (x, y, 15);
     end;
     if x=krastine+2 then antras:=true;
     if not antras
        then if kr=1
                 then x:=x+1
                 else y:=y+1
        else if kr=1
                then y:=y+1
                else x:=x+1;
     if kr=2 then kr:=1 else kr:=kr+1;
   until (x=krastine+2)and(y=krastine+2);
   {gotoxy(x,y);
   write(simb(sk+1))}
   readkey;
end.