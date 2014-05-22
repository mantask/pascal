program mario;

procedure delay (ms : Word); Assembler;
asm
  mov ax, 1000;
  mul ms;
  mov cx, dx;
  mov dx, ax;
  mov ah, $86;
  Int $15;
end;

begin
  asm
    mov  ax, 13h
    int  10h
  end;
  delay (100);
  asm
    mov  ax,  3h
    int 10h
  end;
  writeln;
  Writeln ('  ::MARIO ADVENTURES©::');
  writeln;
  writeln ('LOADING');
  write (' >loading maps...');
  delay (200);
  writeln ('OK');
  write (' >loading graphics...');
  delay (20);
  writeln ('ERROR!');
  writeln;
  writeln ('An error occured while trying to initialize graphics.');
  writeln ('Please try rerunning...');
  repeat until port [$60] < $80;
end.