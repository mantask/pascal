procedure GetJoy (var x, y, z, w : byte; var b1, b2, b3, b4 : boolean);
  var myg : byte;
      xx, yy, zz, ww : byte;
  label l;
begin
  asm
    mov ah, 84h
    mov dx, 1
    int 15h

    mov xx, al
    mov yy, bl
    mov zz, cl
    mov ww, dl

    mov cx, 10h
  l:loop l

    mov ah, 84h
    mov dx, 0
    int 15h

    mov myg, al
  end;
{ NEAISKU KA DARO
  if (myg and 1) = 1 then
  if (myg and 2) = 2 then
  if (myg and 4) = 4 then
  if (myg and 8) = 8 then
}
  x := xx;
  y := yy;
  z := zz;
  w := ww;
  if (myg and 16) = 16 then b1 := false else b1 := true;
  if (myg and 32) = 32 then b2 := false else b2 := true;
  if (myg and 64) = 64 then b3 := false else b3 := true;
  if (myg and 128) = 128 then b4 := false else b4 := true;
end;
