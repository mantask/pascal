{ Gabrieliaus Caplinsko, bet vis tiek geras darbas }
program matrix;

uses
  crt;

type
  act_p=record
    x:byte;
    y:byte;
  end;

var
  m:array [1..79] of act_p;
  xm:array [1..79] of boolean;
  k,k2:integer;
  simb:byte;
  b:word;

function getch(x, y : integer) : char;
  begin
    getch:=chr(mem[$b800:((y-1)*80+x-1)*2]);
  end;

begin
  clrscr;
  for k:=1 to 79 do begin
    m[k].x:=random(79)+1;
    m[k].y:=random(50)+1;
  end;
  repeat
    for k:=1 to 79 do begin
      simb:=random(256);
      if (simb=7) or (simb=8) or (simb=10) or (simb=13) then
        simb:=simb+4;
      if m[k].y<26 then begin
        gotoxy(m[k].x,m[k].y);
        textcolor(10);
        write(chr(simb));
      end;
      textcolor(2);
      for k2:=1 to 2 do
        if (m[k].y-k2<26) and (m[k].y-k2>0) then begin
          gotoxy(m[k].x,m[k].y-k2);
          simb:=random(256);
          if (simb=7) or (simb=8) or (simb=10) or (simb=13) then
            simb:=simb+4;
          write(chr(simb));
        end;
      textcolor(7);
      for k2:=3 to 7 do
        if (m[k].y-k2<26) and (m[k].y-k2>0) then begin
          gotoxy(m[k].x,m[k].y-k2);
          simb:=random(256);
          if (simb=7) or (simb=8) or (simb=10) or (simb=13) then
            simb:=simb+4;
          write(chr(simb));
        end;
      textcolor(8);
      for k2:=7 to 25 do
        if (m[k].y-k2<26) and (m[k].y-k2>0) then begin
          gotoxy(m[k].x,m[k].y-k2);
          simb:=random(256);
          if (simb=7) or (simb=8) or (simb=10) or (simb=13) then
            simb:=simb+4;
          write(chr(simb));
        end;
      textcolor(0);
      for k2:=25 to 25 do
        if (m[k].y-k2<26) and (m[k].y-k2>0) then begin
          gotoxy(m[k].x,m[k].y-k2);
          simb:=random(256);
          if (simb=7) or (simb=8) or (simb=10) or (simb=13) then
            simb:=simb+4;
          write(chr(simb));
        end;
      m[k].y:=m[k].y+1;
      if m[k].y=51 then begin
        repeat
          k2:=random(79)+1;
        until m[k2].y>=26;
        m[k].x:=k2;
        m[k].y:=1;
      end;
    end;
    asm
      mov ax, 3
      int 33h
      mov b, bx
    end;
  until (b>0) or (keypressed);
end.