
program testsprites; { SPRITES2.PAS }
{ Sprites demo, version 2, by Bas van Gaalen,
  inspired on a transparancy-demo by David Dahl }
uses u_vga,u_pal,u_kb;

type
  imgstruc=array[0..8*8-1] of byte;

const
  nofsprites=100;
  template:imgstruc=(
    0,0,0,7,6,0,0,0,
    0,7,7,3,3,5,4,0,
    0,7,3,3,3,3,3,0,
    7,3,3,3,3,3,3,2,
    6,3,3,3,3,3,3,1,
    0,5,3,3,3,3,1,0,
    0,4,3,3,3,1,1,0,
    0,0,0,2,1,0,0,0);

var
  stab1,stab2:array[0..255] of integer;
  bobs:array[0..2] of imgstruc;
  virscr,bckscr:pointer;

{----------------------------------------------------------------------------}

procedure initbobs;
const tbl:array[0..2] of byte=(8,16,32);
var i,x,y:byte;
begin
  for i:=0 to 2 do begin
    bobs[i]:=template;
    for x:=0 to 7 do
      for y:=0 to 7 do
        if bobs[i][y*8+x]>0 then bobs[i][y*8+x]:=bobs[i][y*8+x] or tbl[i];
  end;
end;

procedure buildpal;
var pal:pal_type; i:byte;
begin
  fillchar(pal,sizeof(pal),0);
  for i:=0 to 7 do begin
    { make red, green, and blue bobs }
    pal[i or 08].r:=21+(i*6);
    pal[i or 16].g:=21+(i*6);
    pal[i or 32].b:=21+(i*6);
    { make colors where red and green bobs overlap }
    pal[i or 08 or 16].r:=21+(i*6);
    pal[i or 08 or 16].g:=21+(i*6);
    { make colors where red and blue bobs overlap }
    pal[i or 08 or 32].r:=21+(i*6);
    pal[i or 08 or 32].b:=21+(i*6);
    { make colors where green and blue bobs overlap }
    pal[i or 16 or 32].g:=21+(i*6);
    pal[i or 16 or 32].b:=21+(i*6);
    { make colors where red, green and blue bobs overlap }
    pal[i or 08 or 16 or 32].r:=21+(i*6);
    pal[i or 08 or 16 or 32].g:=21+(i*6);
    pal[i or 08 or 16 or 32].b:=21+(i*6);
  end;
  { make colors where the grey square overlaps the bobs }
  for i:=128 to 255 do begin
    pal[i].r:=(pal[i-128].r div 3)+14;
    pal[i].g:=(pal[i-128].g div 3)+14;
    pal[i].b:=(pal[i-128].b div 3)+14;
  end;
  setpal(pal);
end;

procedure createsprite(nr:byte);
begin
  with sprite[nr] do begin
    xpos:=0; ypos:=0;
    xsize:=8; ysize:=8;
    buf:=@bobs[nr mod 3];
    seethru:=-1;
    transparant:=true;
  end;
end;

{----------------------------------------------------------------------------}

var idxarr1,idxarr2:array[1..maxsprites] of byte; ci,cis,i,j:word;
begin
  setvideo($13);
  initbobs;
  buildpal;
  for i:=1 to nofsprites do begin
    createsprite(i);
    idxarr1[i]:=20+i*3; idxarr2[i]:=50-i*5;
  end;
  for i:=0 to 255 do begin
    stab1[i]:=round(sin(i*2*pi/255)*100)+100;
    stab2[i]:=round(cos(i*2*pi/255)*50)+50;
  end;
  getmem(virscr,64000); cls(virscr,64000);
  getmem(bckscr,64000); cls(bckscr,64000);
  for i:=160 to 319 do for j:=0 to 199 do
    mem[seg(bckscr^):j*320+i]:=128;
  destenation:=bckscr;
  getfont(font8x16);
  writetxt('Apperantly',10,80,255);
  writetxt('this is',20,100,255);
  writetxt('possible',18,120,255);
  flip(bckscr,virscr,64000);
  destenation:=virscr;
  ci:=0; cis:=0;
  {u_border:=true;}
  repeat
    for i:=1 to nofsprites do begin
      movesprabs(i,stab1[idxarr1[i]]+stab2[idxarr2[i]],120+(stab2[idxarr1[i]]-stab1[idxarr2[i]]) shr 1);
      inc(idxarr1[i],1); inc(idxarr2[i],2);
    end;
    vretrace;
    setborder(15);
    for i:=1 to nofsprites do putback(bckscr,virscr,i);
    for i:=1 to nofsprites do putsprite(i);
    setborder(0);
    flip(virscr,vidptr,64000);
    if ci<63 then begin
      setrgb(255,128+ci,128+ci,128+ci);
      inc(cis);
      if cis=2 then begin cis:=0; inc(ci); end;
    end;
  until keypressed;
  freemem(virscr,64000); freemem(bckscr,64000);
  clearkeybuf;
  setvideo(u_lm);
end.
