
program mode_x; { MODEX.PAS }
{ Small demo of the mode-x unit, by Bas van Gaalen }
{ Commandline-parameter: bots.pcx }
uses u_ffpcx,u_vga,u_mdx,u_pal,u_kb;
var pcxpal:pal_type; pcxpic:pointer; i:byte;
begin
  getmem(pcxpic,320*200);
  if pcx_load(paramstr(1),pcxpic,pcxpal)<>pcx_ok then begin
    writeln('An error ocured: ',pcx_errstr); halt; end;
  mdx_setmodex(mdx_320x200,640); { set mode-x, 320x200x256x4 }
  setpal(pcxpal);
  mdx_setcoords(0,200);
  mdx_displaypic(0,200,pcxpic,320,200); { display pcx-picture in 3rd quadrant }
  getfont(font8x16);
  mdx_writetxt('Hi world!',340,220,15); { write text in 4th quadrant }
  mdx_fill(0,0,320,199,blue); { fill first screen with blue background }
  getfont(font8x8);
  mdx_writetxt('This is page number one.',5,10,15); { write text in 1st quad }
  mdx_writetxt('Try to figure that out! :-)',5,18,15);
  mdx_writetxt('Note the _smooth_ horizontal',5,40,7);
  mdx_writetxt('scrolling without disturbance',5,48,7);
  mdx_writetxt('in this part of the screen!',5,56,7);

  waitkey(2);
  for i:=199 downto 0 do begin
    if i=50 then waitkey(1);
    vretrace;
    mdx_setsplit(i shl 1); { move 2nd screen up with doubled speed }
    mdx_setcoords(200-i,200); { move 1st screen left }
  end;
  for i:=1 to 200 do begin
    vretrace;
    mdx_setsplit(i shl 1); { move 2nd screen down with doubled speed }
    mdx_setcoords(200-i,200); { move 1st screen right }
  end;

  waitkey(0);
  freemem(pcxpic,320*200);
  setvideo(u_lm);
end.
