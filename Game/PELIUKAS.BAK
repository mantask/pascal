unit peliukas;

{----------------------------}INTERFACE{-------------------------------------}

procedure InitMouse;
procedure ShowPointer;
procedure HidePointer;
procedure GetXY (var x, y, m : integer);

{--------------------------}IMPLEMENTATION{----------------------------------}

procedure InitMouse; assembler;
asm
  mov ax, 0h
  int 33h
end;

procedure ShowPointer; assembler;
asm
  mov ax, 1h
  int 33h
end;

procedure HidePointer; assembler;
asm
  mov ax, 2h
  int 33h
end;

procedure GetXY (var x, y, m : integer);
  var mm, xx, yy : integer;
begin
  asm
    mov ax, 003h
    int 33h
    mov mm, bx
    mov xx, cx
    mov yy, dx
  end;
  x := xx;
  y := yy;
  m := mm;
end;

end.