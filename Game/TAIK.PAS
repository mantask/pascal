unit taik;

                                INTERFACE

uses graph;

Const sp = 8;
      R = 20;
      stX = 10;
      stY = 10;
      spD = 12;
      spN = 9;
      spTaik = 12;

type Ttaikiklis = object
     private
       xx, yy : integer;
     public
        procedure gaukXY (var x, y : integer);
        procedure keiskXY (x, y : integer);
        procedure piesk;
        procedure valyk;
     end;

     Ttaikinys = object
     private
       SS : pointer;
       xx, yy : integer;
     public
        constructor paruosk;
        procedure gaukXY (var x, y : integer);
        procedure keiskXY (x, y : integer);
        procedure piesk;
        procedure valyk;
        function kelias (x : integer) : integer;
     end;

     Tstatus = object
     private
       sov, pat : byte;
     public
       constructor paruosk;
       procedure piesk;
       procedure pataikei;
       procedure nepataikei;
       function galima : boolean;
       function laimejai : boolean;
     end;

                          IMPLEMENTATION

procedure Ttaikiklis.gaukXY;
begin
  x := xx;
  y := yy;
end;

procedure Ttaikiklis.keiskXY;
begin
  xx := x;
  yy := y;
end;

procedure Ttaikiklis.piesk;
begin
  setcolor (8);
  line (xx - 10, yy - 2, xx - 2, yy - 2);
  line (xx - 10, yy + 2, xx - 2, yy + 2);
  line (xx + 2, yy - 2, xx + 10, yy - 2);
  line (xx + 2, yy + 2, xx + 10, yy + 2);
  line (xx + 2, yy - 10, xx + 2, yy - 2);
  line (xx - 2, yy - 10, xx - 2, yy - 2);
  line (xx + 2, yy + 2, xx + 2, yy + 10);
  line (xx - 2, yy + 2, xx - 2, yy + 10);
end;

procedure Ttaikiklis.valyk;
begin
  setcolor (0);
  line (xx - 10, yy - 2, xx - 2, yy - 2);
  line (xx - 10, yy + 2, xx - 2, yy + 2);
  line (xx + 2, yy - 2, xx + 10, yy - 2);
  line (xx + 2, yy + 2, xx + 10, yy + 2);
  line (xx + 2, yy - 10, xx + 2, yy - 2);
  line (xx - 2, yy - 10, xx - 2, yy - 2);
  line (xx + 2, yy + 2, xx + 2, yy + 10);
  line (xx - 2, yy + 2, xx - 2, yy + 10);
end;

constructor Ttaikinys.paruosk;
  var ck : byte;
      Mx, My : integer;
begin
  cleardevice;
  setcolor (0);
  Mx := getmaxX div 2;
  MY := getmaxY div 2;
  setfillstyle (1, spTaik);
  fillellipse (mx, my, R, R);
  getmem (ss, ImageSize (mx - R, my - R, mx + R, my + R));
  getimage (mx - R, my - R, mx + R, my + R, SS^);
  cleardevice;
end;

procedure Ttaikinys.gaukXY;
begin
  x := xx;
  y := yy;
end;

procedure Ttaikinys.keiskXY;
begin
  xx := x;
  yy := y;
end;

procedure Ttaikinys.piesk;
begin
  putimage (xx - R, yy - R, SS^, 0)
{setfillstyle (1, 1);
fillellipse (xx, yy, 20, 20);
 }
end;

procedure Ttaikinys.valyk;
begin
  setcolor (0);
  setfillstyle (1, 0);
{  fillellipse (xx, yy, 75, 75)}
  bar (xx - R, yy - R, xx + R, yy + R)
end;

function Ttaikinys.kelias;
  var rad : real;
begin
  rad := x / 35;
  kelias := trunc ({75}130 * sin (rad)) + 150;
end;

constructor TSTATUS.paruosk;
begin
  sov := 5;
  pat := 0;
end;

procedure Tstatus.pataikei;
begin
  inc (pat);
  dec (sov);
end;

procedure Tstatus.nepataikei;
begin
  dec (sov)
end;

function Tstatus.laimejai;
begin
  if pat = 3 then laimejai := true
             else laimejai := false;
end;

Function Tstatus.galima;
begin
  if sov > 0 then galima := true
             else galima := false
end;

procedure Tstatus.piesk;
  procedure kulkaY (nr : byte);
    var x, y : integer;
  begin
    y := stY + 7;
    case nr of
      1: x := stX + 20;
      2: x := stX + 30;
      3: x := stX + 40;
      4: x := stX + 50;
      5: x := stX + 60;
    end;
    setcolor (8);
    setfillstyle (1, 8);
    pieslice (x + 2, y, 0, 180, 2);
    Bar (x, y, x + 4, y + 4);
    setcolor (7);
    setfillstyle (1, 7);
    Bar (x, y + 5, x + 4, y + 22);
  end;
  procedure kulkaN (nr : byte);
    var x, y : integer;
  begin
    y := stY + 5;
    case nr of
      1: x := stX + 20;
      2: x := stX + 30;
      3: x := stX + 40;
      4: x := stX + 50;
      5: x := stX + 60;
    end;
    setfillstyle (1, 0);
    bar (x, y, x + 4, y + 24);
  end;
  procedure ratukas (nr : byte; dega : boolean);
    var x, y, R : integer;
  begin
    R := 8;
    Y := stY + 55;
    case nr of
      1: x := stX + 23;
      2: x := stX + 43;
      3: x := stX + 63;
    end;
    setcolor (7);
    if dega then setfillstyle (1, spD)
            else setfillstyle (1, spN);
    FillEllipse (x, y, R, R);
  end;
begin
  setcolor (9);
  rectangle (stX, stY, stX + 85 , stY + 84);
  if sov > 0 then kulkaY (1) else kulkaN (1);
  if sov > 1 then kulkaY (2) else kulkaN (2);
  if sov > 2 then kulkaY (3) else kulkaN (3);
  if sov > 3 then kulkaY (4) else kulkaN (4);
  if sov > 4 then kulkaY (5) else kulkaN (5);
  setcolor (7);
  outtextxy (stx + 20, sty + 34, 'Kulkos');
  if pat > 0 then ratukas (1, true)
             else ratukas (1, false);
  if pat > 1 then ratukas (2, true)
             else ratukas (2, false);
  if pat > 2 then ratukas (3, true)
             else ratukas (3, false);
  setcolor (7);
  outtextXY (stx + 5, sty + 70, 'Pataikymai');
end;

end.
