
program testsprites; { SPRITES3.PAS }
{ Sprites demo, version 3, by Bas van Gaalen }
uses u_vga,u_pal,u_kb;

const
  nofsprites=200;
  spr:array[0..3*3-1] of byte=(1,1,1,1,3,2,1,2,2);

var
  stab1,stab2:array[0..255] of integer;
  virscr,bckscr:pointer;

procedure createsprite(nr:byte);
begin
  with sprite[nr] do begin
    xpos:=0; ypos:=0;
    xsize:=3; ysize:=3;
    buf:=@spr;
    seethru:=-1;
    transparant:=false;
  end;
end;

var idxarr1,idxarr2:array[1..maxsprites] of byte; i,j:integer;
begin
  setvideo($13);
  setrgb(2,20,30,20); setrgb(3,30,40,30); setrgb(1,40,50,40);
  for i:=4 to 250 do setrgb(i,5+i div 5,10+i div 6,i div 4);
  for i:=1 to nofsprites do begin
    createsprite(i);
    idxarr1[i]:=i*3; idxarr2[i]:=60-i*4;
  end;
  for i:=0 to 255 do begin
    stab1[i]:=round(sin(i*2*pi/255)*100)+100;
    stab2[i]:=round(cos(i*2*pi/255)*50)+50;
  end;
  getmem(virscr,64000); cls(virscr,64000);
  getmem(bckscr,64000); cls(bckscr,64000);
  for i:=0 to 319 do for j:=0 to 199 do
    mem[seg(bckscr^):j*320+i]:=4+abs(i-j-60) mod 250;
  flip(bckscr,virscr,64000);
  destenation:=virscr;
  {u_border:=true;}
  repeat
    for i:=1 to nofsprites do begin
      movesprabs(i,10+stab1[idxarr1[i]]+stab2[idxarr2[i]],20+(stab2[idxarr1[i]]+stab1[idxarr2[i]]) shr 1);
      inc(idxarr1[i],2); inc(idxarr2[i],1);
    end;
    vretrace;
    setborder(1);
    for i:=1 to nofsprites do putback(bckscr,virscr,i);
    for i:=1 to nofsprites do putsprite(i);
    setborder(0);
    flip(virscr,vidptr,64000);
  until keypressed;
  freemem(virscr,64000); freemem(bckscr,64000);
  clearkeybuf;
  setvideo(u_lm);
end.
