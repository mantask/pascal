
program small_game; { MINIGAME.PAS }
{ Small shoot'em'up game (right button=exit!), by Bas van Gaalen }
uses crt,u_vga,u_pal,u_mouse;
const
  playerbullits=50; pbacc=5; pbmaxtime=3;
  compbullits=50; cbmaxtime=10; cbspd=3; compspd=2;
  nofstars=99;
type
  posrec=record x,y:integer; end;
  realposrec=record x,y:real; end;
  starsrec=record x:integer; y,spd,col:byte; end;
var
  pbs:array[0..playerbullits] of posrec;
  pbspd:array[0..playerbullits] of byte;
  cbs,cbdir:array[0..compbullits] of realposrec;
  star:array[0..nofstars] of starsrec;
  bckscr,virscr:pointer;
  score:longint;
  px,py,ppx,ppy:word;
  pbtimer,cbtimer,cenergy,penergy,range,cx,cy,pcx,pcy:integer;
  cxd,cyd:shortint;

{ move routines ------------------------------------------------------------ }

procedure moveplayer;
var i:word;
begin
  ppx:=px; ppy:=py;
  px:=getmousex shr 1; py:=getmousey;
  if px<4 then px:=4 else if px>316 then px:=316;
  if py<4 then py:=4 else if py>196 then py:=196;
  if leftpressed then begin
    dec(pbtimer);
    if pbtimer<0 then begin
      pbtimer:=pbmaxtime;
      i:=0;
      while (i<playerbullits) and (pbs[i].x>0) do inc(i);
      if i<playerbullits then begin
        pbs[i].x:=px;
        pbs[i].y:=py;
        pbspd[i]:=1;
      end;
    end;
  end else pbtimer:=0;
end;

procedure movecomputer;
var i:word; rx,ry,difx,dify,big:integer;
begin
  pcx:=cx; pcy:=cy;
  dec(range);
  if range<0 then begin
    range:=random(100);
    case random(8) of
      0:begin cxd:=-1; cyd:=-1; end;
      1:begin cxd:=0; cyd:=-1; end;
      2:begin cxd:=1; cyd:=-1; end;
      3:begin cxd:=1; cyd:=0; end;
      4:begin cxd:=1; cyd:=1; end;
      5:begin cxd:=0; cyd:=1; end;
      6:begin cxd:=-1; cyd:=1; end;
      7:begin cxd:=-1; cyd:=0; end;
    end;
  end;
  inc(cx,cxd*compspd);
  inc(cy,cyd*compspd);
  if cx<4 then begin cx:=4; range:=0; end
  else if cx>316 then begin cx:=316; range:=0; end;
  if cy<4 then begin cy:=4; range:=0; end
  else if cy>196 then begin cy:=196; range:=0; end;
  dec(cbtimer);
  if cbtimer<0 then begin
    cbtimer:=random(cbmaxtime);
    i:=0;
    while (i<compbullits) and (cbs[i].x>0) do inc(i);
    if i<compbullits then begin
      rx:=random(10)-5; ry:=random(10)-5;
      cbs[i].x:=cx;
      cbs[i].y:=cy;
      if cx>(px+rx) then difx:=cx-(px+rx) else difx:=(px+rx)-cx;
      if cy>(py+ry) then dify:=cy-(py+ry) else dify:=(py+ry)-cy;
      if difx>dify then big:=difx else big:=dify;
      if big<>0 then begin
        cbdir[i].x:=cbspd*(difx/big);
        cbdir[i].y:=cbspd*(dify/big);
        if cx>(px+rx) then cbdir[i].x:=-cbdir[i].x;
        if cy>(py+ry) then cbdir[i].y:=-cbdir[i].y;
      end;
    end;
  end;
end;

procedure moveplayerbullits;
var i:word;
begin
  for i:=0 to playerbullits do
    if pbs[i].x>0 then begin
      dec(pbs[i].y,pbspd[i]);
      if (pbs[i].y mod pbacc)=0 then inc(pbspd[i]);
      if pbs[i].y<0 then begin
        pbs[i].x:=0; pbs[i].y:=0; pbspd[i]:=0;
      end;
    end;
end;

procedure movecompbullits;
var i:word;
begin
  for i:=0 to compbullits do
    if cbs[i].x>0 then begin
      cbs[i].x:=cbs[i].x+cbdir[i].x;
      cbs[i].y:=cbs[i].y+cbdir[i].y;
      if (cbs[i].x<4) or (cbs[i].x>316) or
         (cbs[i].y<4) or (cbs[i].y>196) then begin
        cbs[i].x:=0; cbs[i].y:=0;
        cbdir[i].x:=0; cbdir[i].y:=0;
      end;
    end;
end;

procedure movestars;
var i:byte;
begin
  for i:=0 to nofstars do begin
    dec(star[i].x,star[i].spd);
    if star[i].x<0 then
      with star[i] do begin
        x:=319;
        y:=random(200);
        spd:=succ(random(3));
        col:=16+spd;
      end;
  end;
end;

{ check collisions --------------------------------------------------------- }

procedure resetgame;
begin
  fillchar(pbs,sizeof(pbs),0);
  fillchar(pbspd,sizeof(pbspd),0);
  fillchar(cbs,sizeof(cbs),0);
  fillchar(cbdir,sizeof(cbdir),0);
  pbtimer:=pbmaxtime; cbtimer:=random(cbmaxtime);
  cx:=4+random(312); cy:=4+random(192);
  px:=0; py:=0;
  range:=0;
  score:=0;
  cenergy:=100;
  penergy:=100;
end;

procedure checkall;
var i:word; dx,dy:integer;
begin
  i:=0; { player bullits hit computer }
  while (i<playerbullits) and (pbs[i].x>0) do begin
    dx:=(cx-pbs[i].x)+3;
    dy:=(cy-pbs[i].y)+3;
    if (dx>=0) and (dx<=6) and
       (dy>=0) and (dy<=6) then begin
      inc(score);
      dec(cenergy);
      if cenergy<0 then begin
        destenation:=ptr($a000,0);
        writetxt('YOU WON',130,96,15);
        destenation:=virscr;
        delay(1000);
        repeat until leftpressed;
        resetgame;
      end;
    end;
    inc(i);
  end;
  i:=0; { computer bullits hit player }
  while (i<compbullits) and (cbs[i].x>0) do begin
    dx:=(px-round(cbs[i].x))+3;
    dy:=(py-round(cbs[i].y))+3;
    if (dx>=0) and (dx<=6) and
       (dy>=0) and (dy<=6) then begin
      dec(penergy);
      if penergy<0 then begin
        destenation:=ptr($a000,0);
        writetxt('GAME OVER!',120,96,15);
        destenation:=virscr;
        delay(1000);
        repeat until leftpressed;
        resetgame;
      end;
    end;
    inc(i);
  end;
end;

{ draw all stuff to screen ------------------------------------------------- }

procedure drawall;
var scorestr:string; lcbx,lcby,i:word;
begin
  for i:=0 to nofstars do putpixel(star[i].x,star[i].y,star[i].col);
  { player }
  putpixel(px,py,15);
  putpixel(px-1,py+1,7);
  putpixel(px+1,py+1,7);
  putpixel(px-2,py+2,8);
  putpixel(px+2,py+2,8);
  { computer }
  putpixel(cx-1,cy-1,8);
  putpixel(cx,cy-1,3);
  putpixel(cx+1,cy-1,8);
  putpixel(cx-1,cy,3);
  putpixel(cx+1,cy,3);
  putpixel(cx-1,cy+1,8);
  putpixel(cx,cy+1,3);
  putpixel(cx+1,cy+1,8);
  { player bullits }
  for i:=0 to playerbullits do
    if pbs[i].x>0 then begin
      putpixel(pbs[i].x,pbs[i].y-2,15);
      putpixel(pbs[i].x,pbs[i].y-1,9);
      putpixel(pbs[i].x,pbs[i].y,1);
    end;
  { computer bullits }
  for i:=0 to compbullits do
    if cbs[i].x>0 then begin
      lcbx:=round(cbs[i].x); lcby:=round(cbs[i].y);
      putpixel(lcbx,lcby,15);
      putpixel(lcbx,lcby+1,4);
      putpixel(lcbx,lcby-1,4);
      putpixel(lcbx+1,lcby,4);
      putpixel(lcbx-1,lcby,4);
    end;
  { score }
  str(score:3,scorestr);
  writetxt(scorestr,10,190,15);
  { penergy-bar }
  for i:=199 downto (199-penergy) do begin
    putpixel(1,i,8);
    putpixel(2,i,15);
    putpixel(3,i,8);
  end;
  { cenergy-bar }
  for i:=199 downto (199-cenergy) do begin
    putpixel(316,i,3);
    putpixel(317,i,15);
    putpixel(318,i,3);
  end;
  vretrace;
  flip(virscr,ptr($a000,0),64000);
end;

procedure clearall;
var lcbx,lcby,i,j:word;
begin
  for i:=0 to nofstars do putpixel(star[i].x,star[i].y,0);
  { player }
  putpixel(px,py,0);
  putpixel(px-1,py+1,0);
  putpixel(px+1,py+1,0);
  putpixel(px-2,py+2,0);
  putpixel(px+2,py+2,0);
  { computer }
  putpixel(cx-1,cy-1,0);
  putpixel(cx,cy-1,0);
  putpixel(cx+1,cy-1,0);
  putpixel(cx-1,cy,0);
  putpixel(cx+1,cy,0);
  putpixel(cx-1,cy+1,0);
  putpixel(cx,cy+1,0);
  putpixel(cx+1,cy+1,0);
  { player bullits }
  for i:=0 to playerbullits do
    if pbs[i].x>0 then begin
      putpixel(pbs[i].x,pbs[i].y-2,0);
      putpixel(pbs[i].x,pbs[i].y-1,0);
      putpixel(pbs[i].x,pbs[i].y,0);
    end;
  { computer bullits }
  for i:=0 to compbullits do
    if cbs[i].x>0 then begin
      lcbx:=round(cbs[i].x); lcby:=round(cbs[i].y);
      putpixel(lcbx,lcby,0);
      putpixel(lcbx,lcby+1,0);
      putpixel(lcbx,lcby-1,0);
      putpixel(lcbx+1,lcby,0);
      putpixel(lcbx-1,lcby,0);
    end;
  { score }
  for i:=0 to 7 do for j:=0 to 4*8 do putpixel(10+j,190+i,0);
  { penergy-bar }
  for i:=199 downto 99 do begin
    putpixel(1,i,0);
    putpixel(2,i,0);
    putpixel(3,i,0);
  end;
  { cenergy-bar }
  for i:=199 downto 99 do begin
    putpixel(316,i,0);
    putpixel(317,i,0);
    putpixel(318,i,0);
  end;
end;

{ main --------------------------------------------------------------------- }

var i:byte;
begin
  if not mouseinstalled then begin writeln('Needs mouse!'); halt; end;
  randomize;
  mousesensetivity(20,20);
  usefont:=font8x8;
  setvideo($13);
  getmem(virscr,64000); cls(virscr,64000); destenation:=virscr;
  for i:=0 to 5 do setrgb(16+i,10+i*5,10+i*3,15+i*10);
  for i:=0 to nofstars do
    with star[i] do begin
      x:=random(320);
      y:=random(200);
      spd:=succ(random(3));
      col:=16+spd;
    end;
  resetgame;
  repeat
    moveplayer;
    movecomputer;
    moveplayerbullits;
    movecompbullits;
    movestars;
    checkall;
    drawall;
    clearall;
  until rightpressed;
  freemem(virscr,64000);
  setvideo(u_lm);
end.

{
  'features':
  - players autofire is slower than a trigger-happy manual-fire.
  - for computer-player:
    the higher number of bullits and the lower the maxtime, the harder it
    gets for the person-player, and vice-versa, if you know what I mean.
  - You can make it al realy impossible for yourself, it you set:
    compbullits=50, cbmaxtime=5, cbspd=3, for instance.
}
