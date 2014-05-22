program sklypai;
var x11, x12, y11, y12,
    x21, x22, y21, y22,
    x31, x32, y31, y32,
    xs1, xs2, ys1, ys2,
    s: integer;
    nesiliecia: boolean;
begin
   readln(x11,y11, x12,y12, x21,y21, x22,y22, x31,y31, x32,y32);
   if x21 in [x11..x12]
        then xs1:=x21
        else
           if x21<x11
              then xs1:=x11
              else nesiliecia:=true;
   if x22 in [x11..x12]
        then xs2:=x22
        else
           if x22>x12
              then xs2:=x12
              else nesiliecia:=true;
   if y21 in [y11..y12]
        then ys1:=y21
           else
              if y21<y11
                 then ys1:=y11
                 else nesiliecia:=true;
   if y22 in [y11..y12]
        then ys2:=y22
        else
           if y22>y12
              then ys2:=y12
              else nesiliecia:=true;
   if x31 in [xs1..xs2]
        then xs1:=x31
        else
           if x31<xs1
              then xs1:=xs1
              else nesiliecia:=true;
   if x32 in [xs1..xs2]
        then xs2:=x32
        else
           if x32>xs2
              then xs2:=xs2
              else nesiliecia:=true;
   if y31 in [ys1..ys2]
       then ys1:=y31
           else
              if y31<ys1
                 then ys1:=ys1
                 else nesiliecia:=true;
   if y32 in [ys1..ys2]
        then ys2:=y32
        else
           if y32>ys2
              then ys2:=ys2
              else nesiliecia:=true;

   if not nesiliecia then s:=(xs2-xs1)*(ys2-ys1);
   writeln(s);
end.

