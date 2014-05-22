program joy;
  uses graph;
  var sx, sy, sz, sv,
      x, y, z, v : word;
      sa, sb, sc, sd,
      a, b, c, d : boolean;
      gm, gd : integer;

  procedure GetJoy (var x, y, z, W : word; var b1, b2, b3, b4 : boolean);
    var myg : byte;
        xx, yy, zz, ww : word;
    label l;
  begin
    asm
      mov ah, 84h
      mov dx, 1
      int 15h

      mov xx, ax
      mov yy, bx
      mov zz, cx
      mov ww, dx

      mov cx, 10h
    l:loop l

      mov ah, 84h
      mov dx, 0
      int 15h

      mov myg, al
    end;
  { NEAISKU KA DARO }
{
    if (myg and 1) = 1 then
    if (myg and 2) = 2 then
    if (myg and 4) = 4 then
    if (myg and 8) = 8 then
}
    x := xx;
    y := yy;
    z := zz;
    w := ww;
    if (myg and  16) =  16 then b1 := false else b1 := true;
    if (myg and  32) =  32 then b2 := false else b2 := true;
    if (myg and  64) =  64 then b3 := false else b3 := true;
    if (myg and 128) = 128 then b4 := false else b4 := true;
  end;


begin
  initgraph (gm, gd, '');

  setcolor (7);
  moveto (250, 0);
  outtext ('Joystick test');
  moveto (285, 470);
  outtext ('MK 2001');
  moveto (18, 18);
  outtext ('myg1');
  moveto (18, 38);
  outtext ('myg2');
  moveto (18, 58);
  outtext ('myg3');
  moveto (18, 78);
  outtext ('myg4');
  setcolor (1);
  rectangle (1, 104, 13, 272);
  setcolor (8);
  rectangle (52, 10, 585, 467);
  setcolor (9);
  rectangle (1, 15, 13, 25);
  rectangle (1, 35, 13, 45);
  rectangle (1, 55, 13, 65);
  rectangle (1, 75, 13, 85);

  sx := 2;
  sy := 2;
  repeat
    getjoy (x, y, z, v, a, b, c, d);
    x := 3 * x + 40; y := round (y * 2.5) ; v := v + 100;
    if (x <> sx) or (y <> sy) then
    begin
      setcolor (0);
      rectangle (sx - 2, sy - 2, sx + 2, sy + 2);
      setcolor (15);
      rectangle (x - 2, y - 2, x + 2, y + 2);
    end;
    if (v <> sv) then
    begin
      setcolor (0);
      line (2, sv, 12, sv);
      setcolor (9);
      line (2, v, 12, v);
    end;
    if a <> sa then
    begin
      if a then setcolor (12) else setcolor (9);
      rectangle (1, 15, 13, 25);
    end;
    if b <> sb then
    begin
      if b then setcolor (12) else setcolor (9);
      rectangle (1, 35, 13, 45);
    end;
    if c <> sc then
    begin
      if c then setcolor (12) else setcolor (9);
      rectangle (1, 55, 13, 65);
    end;
    if d <> sd then
    begin
      if d then setcolor (12) else setcolor (9);
      rectangle (1, 75, 13, 85);
    end;

    sx := x; sy := y; sz := z; sv := v;
    sa := a; sb := b; sc := c; sd := d;
  until port [$60] = 1;
  closegraph;
end.