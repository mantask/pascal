
program bigscroll; { SCR_HUGE.PAS }
uses u_vga,u_kb;
const
  vidptr=ptr($b800,0);
  xs=4; ys=3;
  txt:string='Large and bright enough?   ';
var
  virscr:pointer;

procedure ssl(buf:pointer); assembler; { scrolls text screen left }
asm
  push ds
  les di,buf
  lds si,buf
  add si,2
  mov dx,48
 @l0:
  mov cx,79
  rep movsw
  add si,2
  add di,2
  dec dl
  jnz @l0
  pop ds
end;

procedure scroll;
var poke:word; s,x,x2,y,y2,ch,txtidx:byte;
begin
  txtidx:=1;
  repeat
    ch:=byte(txt[txtidx]);
    txtidx:=1+txtidx mod length(txt);
    for x:=7 downto 0 do
      for x2:=1 to xs do begin
        vretrace;
        ssl(virscr);
        for y:=0 to 15 do begin
          if boolean((mem[seg(font^):ofs(font^)+ch*16+y] shr x) and 1) then
            poke:=$0adb else poke:=$0020;
          for y2:=0 to ys-1 do memw[seg(virscr^):ofs(virscr^)+(y*ys+y2)*160+158]:=poke;
        end;
        flip(virscr,vidptr,2*80*50);
      end;
  until keypressed;
end;

begin
  setvideo(259); { needs VGA }
  getfont(font8x16);
  getmem(virscr,2*80*50); cls(virscr,2*80*50);
  scroll;
  freemem(virscr,2*80*50);
  setvideo(u_lm);
end.
