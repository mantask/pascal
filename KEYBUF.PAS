program Keyboard_buffer_write;
  uses crt;
  var c : char;
begin
  asm
    mov ah, 5
{    mov ch, <scancode> ;but doesn't work as should}
    mov cl,'a'
    int 16h

    mov cx, 2000h {padaromas nedidelis laiko tarpelis tarp int inicializavimo}
@@1:loop @@1

    mov ah, 5
    mov cl, 'f'
    int 16h

    mov cx, 2000h
@@2:loop @@2

    mov ah, 5
    mov cl, 'h'
    int 16h
  end;
  while keypressed do
  begin
    c := readkey;
    writeln (c, ' - ', ord (c));
  end;
  writeln
end.