
program paltest; { PALTEST.PAS }
{ Simple demonstration of the pal-unit functions, by Bas van Gaalen }
{ Commandline-parameter: bots.pcx }
uses u_vga,u_ffpcx,u_pal,u_kb;
var pal,pal2:pal_type; pcxpic:pointer; i:byte;
begin
  getmem(pcxpic,320*200);
  if pcx_load(paramstr(1),pcxpic,pal)<>pcx_ok then begin
    writeln('An error ocured: ',pcx_errstr); halt; end;
  move(pal,pal2,sizeof(pal)); { save original pal }
  setvideo($13);
  clearpal; { clear current palette }
  displaypic(0,0,pcxpic,320,200); { place picture on screen (in black) }
  freemem(pcxpic,320*200);
  fadeup(pal); { fade-in to picture-colors }
  waitkey(1);
  for i:=0 to 255 do begin { init blue-scale pal }
    pal[i].r:=i shr 4;
    pal[i].g:=i shr 3;
    pal[i].b:=i shr 2;
  end;
  fadepal(pal); { fade current pal to blue-scale pal }
  waitkey(1);
  repeat
    vretrace; { cycle is interactive - add vertical retrace }
    cyclepal(0,255,-1); { cycle through gray-scale pal }
  until keypressed;
  clearkeybuf;
  fademax; { fade current pal to white }
  waitkey(1);
  fadepal(pal2); { fade through original color down to black }
  fadedown;
  setvideo(u_lm);
end.
