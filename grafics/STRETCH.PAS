
program stretch; { STRETCH.PAS }
{ Full Screen Hardware Stretch, by Bas van Gaalen }
uses u_vga,u_ffpcx,u_pal,u_kb;
var pcxpal:pal_type; pcxpic:pointer; i,j:word;
begin
  getmem(pcxpic,64000);
  if pcx_load(paramstr(1),pcxpic,pcxpal)<>pcx_ok then begin
    writeln('An error ocured: ',pcx_errstr); halt; end;
  setvideo($13);
  setpal(pcxpal);
  portw[$3d4]:=$13+0 shl 8;
  displaypic(0,0,pcxpic,320,200);
  i:=0; waitkey(1);
  repeat
    vretrace;
    portw[$3d4]:=$13+40 shl 8;
    for j:=0 to i do hretrace;
    portw[$3d4]:=$13+0 shl 8;
    inc(i);
  until keypressed or (i=399);
  portw[$3d4]:=$13+40 shl 8;
  waitkey(1);
  repeat
    vretrace;
    portw[$3d4]:=$13+40 shl 8;
    for j:=0 to i do hretrace;
    portw[$3d4]:=$13+0 shl 8;
    dec(i);
  until keypressed or (i=0);
  waitkey(1);
  freemem(pcxpic,64000);
  setvideo(u_lm);
end.
