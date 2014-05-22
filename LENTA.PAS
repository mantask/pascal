program arklys;
const ilgis = 5;
      vx: array [0..7] of integer = (-1, 1, -1, 1, -2, 2, -2, 2);
      vy: array [0..7] of integer = (2, 2, -2, -2, 1, 1, -1, -1);
type mas = array [1..ilgis,1..ilgis] of integer;
var lenta: mas;
    x1, y1, eina: integer;


procedure judejimas (x,y: integer; var ln: mas; var ejimai: integer);
  var ck,ck1: integer;
begin
 ln [x,y] := ejimai;
 if ejimai = ilgis * ilgis then begin
   for ck:= 1 to ilgis do begin
    for ck1 := 1 to ilgis do
       write (ln [ck,ck1]:3);
    writeln;
    end;
     exit
    end;
 for ck := 0 to 7 do
    if ((x + vx[ck]) in [1..ilgis]) and ((y + vy[ck]) in [1..ilgis])
         and (ln [x + vx [ck], y + vy [ck]] = 0)
       then
          begin
            inc (ejimai);
            judejimas (x + vx[ck],  y + vy[ck], ln, ejimai);
            dec (ejimai)
          end;
 ln [x,y] := 0
end;


begin
  eina := 1; readln (x1,y1);
  judejimas (x1,y1, lenta, eina)

end.