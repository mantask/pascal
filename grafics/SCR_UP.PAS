
{$define cpu386}

program creditscroll; { SCR_UP.PAS }
{ Plain and simple scroll, by Bas van Gaalen }
uses u_vga,u_mdx,u_kb;
const
  lines=45;
  txt:array[0..lines-1] of string[30]=(
   {.........|.........|.........|}
    'This is a credits-scroll',
    'in mode-q: 256x256x256.',
    'That''s a chained mode, with',
    'a lineair addressing sceme.',
    'The graphics-screen is',
    'initialized in the unit',
    'umodeq. It''s enclosed in the',
    'next message (I hope).','','',
    'and so the credits go to','','',
    '...Bas van Gaalen...','','',
    'Btw: this is quite lame:',
    'not even a hardware-scroll!',
    'But it''s just to show the',
    'nice overscan-mode...','',
    'Uuuhm, can someone supply',
    'some shit, to fill up this',
    'text?','',
    'Oyeah, before I forget,',
    'mode-q is a tweaked mode,',
    'and it plays a bit with the',
    'VGA-registers!',
    'So again: I won''t take any',
    'responsebilty for this code!',
    'It works fine on my ET-4000.','','','',
    '','','','','','','','','','');

procedure moveup; assembler;
asm
  push ds
  mov es,u_vidseg
  mov ds,u_vidseg
  xor di,di
  mov si,0100h
{$ifdef cpu386}
  mov cx,255*256/4
  db $66; rep movsw
{$else}
  mov cx,255*256/2
  rep movsw
{$endif}
  pop ds
end;

var i,j,slidx,txtidx:byte;
begin
  mdx_setmodex(mdx_256x256c,256);
  getfont(font8x8);
  txtidx:=0; slidx:=0;
  repeat
    for i:=1 to length(txt[txtidx]) do for j:=0 to 7 do
      if ((mem[seg(font^):ofs(font^)+ord(txt[txtidx][i])*8+slidx] shl j) and 128)<>0 then
        mem[u_vidseg:$fe00+i*8+(256-8*length(txt[txtidx])) div 2+j]:=32+txtidx+slidx+j;
    vretrace;
    moveup;
    slidx:=(1+slidx) mod 8;
    if slidx=0 then txtidx:=(1+txtidx) mod lines;
  until keypressed;
  setvideo(u_lm);
end.
