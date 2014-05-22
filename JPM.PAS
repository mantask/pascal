{$M 65384,0,655360}

program jpm;
  uses crt;
  type Tlenta = array [1 .. 5, 1 .. 5] of boolean;
  const k : array [0 .. 3, 0 .. 1] of integer = ((1,0),(0,1),(-1,0),(0,-1));
  var lenta, kelias : Tlenta;
      x, y, ilgis, max, min: integer;

  procedure f (x, y, kr, ilgis: integer; kelias: Tlenta; var max, min: integer);
    var xx, yy: integer;
  begin
    if (kelias [x + k [kr,0], y + k [kr,1]]) then
                    begin
                        if ilgis >= max then max := ilgis;
                        if ilgis <= min then min := ilgis;
                        exit
                    end
        else
          begin
             clrscr; gotoxy (1,1);
             for yy:=1 to 5 do
               begin
                for xx := 1 to 5 do
                   if lenta[xx,yy] = true then write ('*') else if
                      kelias[xx,yy] = true then write (':') else write ('.');
                 writeln;
               end;
             readkey;
             x := x + k [kr, 0];
             y := y + k [kr, 1];
             while not lenta [x,y] and not (kelias [x, y])
               and (x in [1..10]) and (y in [1..10]) do
               begin
                  kelias [x,y] := true;
                  x := x + k [kr, 0];
                  y := y + k [kr, 1];
                  inc (ilgis);
               end;
             x := x - k [kr, 0];
             y := y - k [kr, 1];
             f (x, y, (kr + 1) mod 4, ilgis, kelias, max, min);
             f (x, y, (kr + 3) mod 4, ilgis, kelias, max, min);

          end;
  end;

begin
    clrscr;
    lenta [1, 2] := true;
    lenta [4, 3] := true;
    lenta [4, 5] := true;
    kelias [1,5] := true;
    ilgis := 1;
    f ( 1, 5, 3, ilgis, kelias, max, min);
    writeln (max,' ', min);
end.
