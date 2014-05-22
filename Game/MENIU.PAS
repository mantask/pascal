unit meniu;

interface

 type Tnr = 1 .. 4;
      Tpagrmeniu = object
      private
        ziba : Tnr;
        procedure mygtukas (nr : Tnr);
      public
        constructor paruosk;
        function klavisas (code : byte) : byte;
        function pele (x, y, m : integer) : byte;
      end;

implementation

 uses graph, crt;

procedure Tpagrmeniu.mygtukas;
  const name : array [1 .. 4] of string [10] = ('Begin', 'High Score', 'About', 'Exit');
  var x, y : integer;
begin
    x := 300;
    case nr of
       1 : y :=  80;
       2 : y := 160;
       3 : y := 240;
       4 : y := 320;
     end;
     setcolor (0);
     if ziba <> nr then setfillstyle (1, 5) else setfillstyle (10, 5);
     bar (x, y, x + 100 , y + 60);
     outtextxy (x + 10, y + 20, name [nr]);
end;

constructor Tpagrmeniu.paruosk;
 var nr : byte;
begin
  ziba := 1;
  for nr := 1 to 4 do mygtukas (nr);
end;

function Tpagrmeniu.klavisas;
var sm : Tnr;
begin
  case code of
    13 : klavisas := ziba;
    72, 75 : begin sm := ziba; ziba := (ziba + 4) div 6 + 1; mygtukas (sm); mygtukas (ziba) end;
    80, 77 : begin sm := ziba; ziba := (ziba + 1) div 6 + 1; mygtukas (sm); mygtukas (ziba) end;
  end;
  if code <> 13 then klavisas := 0;
end;

function Tpagrmeniu.pele;
 var sm : Tnr;
begin
  if (x >= 300) and (x <= 400) then
    begin
     if (y >= 80) and (y <= 140) and (ziba <> 1) then
       begin
         sm := ziba;
         ziba := 1;
         mygtukas (sm);
         mygtukas (ziba);
         if (m and 1) = 1 then pele := 1;
       end;
     if (y >= 160) and (y <= 220) and (ziba <> 2) then
       begin
         sm := ziba;
         ziba := 2;
         mygtukas (sm);
         mygtukas (ziba);
         if (m and 1) = 1 then pele := 2;
       end;
     if (y >= 240) and (y <= 280) and (ziba <> 3) then
     begin
         sm := ziba;
         ziba := 3;
         mygtukas (sm);
         mygtukas (ziba);
         if (m and 1) = 1 then pele := 3;
       end;
     if (y >= 320) and (y <= 360) and (ziba <> 4) then
       begin
         sm := ziba;
         ziba := 4;
         mygtukas (sm);
         mygtukas (ziba);
         if (m and 1) = 1 then pele := 4;
       end;
   end
   else pele := 0;
end;

end.