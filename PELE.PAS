program pele;
   uses crt;
   var x,xx, x1, y,yy, y1, m : word;
begin
  clrscr;
  asm
    mov ax,1
    int 33h
  end;
  xx := 10; yy := 5;
  gotoxy (xx,yy); textcolor(3); writeln ('999');

  x1 := 1; y1 := 1;
  repeat
    asm
      mov ax,3     { i ax rasai 3, t.y. paruosi registrus grazinti duomenis apie peles bukle}
      int 33h      { initialize 33, pats nezinau, turbut paruosia registrus darbui su pele }
      mov m,bx     { i m rasai is bx registro}
      mov x,cx     { i x rasai is cx registro}
      mov y,dx     { i y rasai is dx registro}
    end;
    x := x div 8 + 1; y := y div 8 + 1;
    if (m = 1) and ((x1 <> x) or (y1 <> y)) and (x in [xx .. (xx + 2)]) and
     (yy = y) then begin
        gotoxy (xx,yy); writeln ('   ');
        xx := xx - (x1 - x); yy := yy - (y1 - y);
        gotoxy (xx, yy); writeln ('999');
        end;
    x1 := x; y1 := y;
  until m = 2;                                     {desinysis myg}
  asm
    mov cx,0
  end;
end.