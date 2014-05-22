
program scale; { SCALE.PAS }
{ Scale and mirror bitmap demo, by Bas van Gaalen }
uses u_vga,u_ffpcx,u_pal,u_kb;
const
  dir:shortint=3;
  ptab:array[0..255] of byte=(
    123,121,119,117,115,114,112,110,108,106,104,103,101,99,97,96,94,92,91,
    89,87,86,84,82,81,79,78,76,75,73,72,70,69,67,66,64,63,62,60,59,58,56,
    55,54,52,51,50,49,48,46,45,44,43,42,41,39,38,37,36,35,34,33,32,31,30,
    29,28,27,26,26,25,24,23,22,21,21,20,19,18,17,17,16,15,15,14,13,13,12,
    12,11,10,10,9,9,8,8,7,7,6,6,5,5,5,4,4,4,3,3,3,2,2,2,2,1,1,1,1,1,1,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,5,5,6,6,
    7,7,7,8,8,9,9,10,11,11,12,12,13,14,14,15,16,16,17,18,19,19,20,21,22,
    23,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,
    46,47,48,49,51,52,53,54,56,57,58,60,61,62,64,65,67,68,69,71,72,74,75,
    77,78,80,82,83,85,86,88,90,91,93,95,96,98,100,102,103,105,107,109,111,
    113,114,116,118,120,122,124,126);

var
  stab:array[0..255] of shortint;
  pcxpal:pal_type;
  pcxpic,virscr:pointer;
  xobj,i,virseg:word;
  vx,vy,vx2,vy2, { virtual }
  x,y,x2,y2, { real }
  px,py,px2,py2:integer; { previous }
  pidx,j,k:byte;

begin
  getmem(pcxpic,64000);
  if pcx_load(paramstr(1),pcxpic,pcxpal)<>pcx_ok then begin
    writeln('An error ocured: ',pcx_errstr); halt; end;
  setvideo($13);
  setpal(pcxpal);

  getmem(virscr,64000); cls(virscr,64000); virseg:=seg(virscr^);
  destenation:=virscr; { destenation is now virtual screen }

  { bump'n'scale picture }
  pidx:=128; px:=0; py:=0; px2:=0; py2:=0; vx:=10;
  repeat
    vga_fill(px,py,px2,py2,0); { clear old pos }
    if (vx<-50) or (vx>260) then dir:=-dir; { calculate virtual positions }
    vy:=25+ptab[pidx]; vy2:=vy+100; inc(pidx,4);
    if vy2<200 then inc(vx,dir);
    vx2:=vx+100;
    x:=vx; if x<0 then x:=0; { derive screen positions }
    x2:=vx2; if x2>319 then x2:=319;
    y:=vy;
    y2:=vy2; if y2>199 then y2:=199;
    px:=x; px2:=x2; py:=y; py2:=y2; { set previous coords }
    vretrace;
    scalepic(pcxpic,320,200,x,y,x2,y2); { draw scaled picture on virscreen }
    flip(virscr,vidptr,64000);
  until keypressed;
  clearkeybuf;

  { rotate pictures, vertical and horizontal }
  cls(virscr,64000);
  cls(vidptr,64000);
  for j:=0 to 255 do stab[j]:=round(cos(2*pi*j/255)*50);
  k:=128;
  repeat
    vga_fill(40,50,280,150,0);
    scalepic(pcxpic,320,200,40,100-stab[j],140,100+stab[j]);
    scalepic(pcxpic,320,200,230-stab[k],50,230+stab[k],150);
    flip(ptr(virseg,50*320),ptr($a000,50*320),150*320);
    inc(j,3); inc(k,4);
  until keypressed;
  clearkeybuf;
  freemem(virscr,64000);

  { zoom in - with right and bottom clipping! }
  destenation:=vidptr; { destenation is now visual screen }
  cls(vidptr,64000);
  i:=1; j:=1;
  repeat
    scalepic(pcxpic,320,200,0,0,i,j);
    inc(i,3); inc(j);
  until keypressed or (j>200);
  waitkey(5);

  { mirror to four directions }
  cls(vidptr,64000);
  scalepic(pcxpic,320,200,0,0,150,90);
  scalepic(pcxpic,320,200,310,0,160,90);
  scalepic(pcxpic,320,200,0,190,150,100);
  scalepic(pcxpic,320,200,310,190,160,100);
  waitkey(5);

  { randomly scale'n'mirror }
  cls(vidptr,64000);
  randomize;
  repeat
    scalepic(pcxpic,320,200,random(320),random(200),random(320),random(200));
  until keypressed;
  waitkey(1);

  freemem(pcxpic,64000);
  setvideo(u_lm);
end.
