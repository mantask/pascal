{ ============================ }
{ MoKa 2 Mantas Kanaporis 2001 }
{ ============================ }
Program MoKa2;
  uses crt;
  const fonas = 0; akt = 3; neakt = 2; tekst = 0; grad = 7;{spalvos}

  var ck : integer;

  {paslepia kursoriu}
  procedure HIDE_CURSOR; assembler;
  asm
    mov ah, 1
    mov ch, 20h
    int 10h
  end;

  {atstato kursoriu}
  procedure SHOW_CURSOR; assembler;
  asm
    mov ah, 1
    mov ch, 1eh
    mov cl, 1fh
    int 10h
  end;


  {nuvalo ir paruosia darbini ekrana}
  Procedure EKRANAS;
    var ck: integer;
  begin
     textbackground (akt); textcolor (tekst); clrscr;
     gotoxy (2, 1); writeln ('[þ]', '   MoKa 2 Mantas Kanaporis 2001');
     textbackground (neakt); for ck := 1 to 80 do write (' ');
     textbackground (fonas); window (1, 3, 80, 24); clrscr; window (1, 1, 80, 25);
  end;

begin

{ijungiama pele}
   asm
     mov ax, 1
     int 33h
   end;
{-=:=-}
   hide_cursor;
   ekranas;
   readln
end.