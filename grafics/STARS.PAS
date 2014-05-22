
program _stars; { STARS.PAS }
{ Starry sky, based on something someone posted sometime somewhere,
  by Bas van Gaalen }
uses u_vga,u_pal,u_kb;
const
  f=6;
  nofstars=100;
  bitmask:array[boolean,0..4,0..4] of byte=(
    ((0,0,1,0,0),
     (0,0,3,0,0),
     (1,3,6,3,1),
     (0,0,3,0,0),
     (0,0,1,0,0)),
    ((0,0,6,0,0),
     (0,0,3,0,0),
     (6,3,1,3,6),
     (0,0,3,0,0),
     (0,0,6,0,0)));

type
  starstruc=record
    xp,                 { coordinates }
    yp:word;
    phase,              { fase in which the star can be found (bitmask) }
    col:byte;           { color }
    dur:shortint;       { speed of succesive steps }
    active:boolean;     { is the star currently active or not? }
  end;

var
  stars:array[1..nofstars] of starstruc;

var i,x,y:word;
begin
  setvideo($13);
  for i:=1 to 10 do begin
    setrgb(i,f*i,0,0); setrgb(21-i,f*i,0,0); setrgb(20+i,0,0,0);
    setrgb(30+i,0,f*i,0); setrgb(51-i,0,f*i,0); setrgb(50+i,0,0,0);
    setrgb(60+i,0,0,f*i); setrgb(81-i,0,0,f*i); setrgb(80+i,0,0,0);
    setrgb(90+i,f*i,f*i,0); setrgb(111-i,f*i,f*i,0); setrgb(110+i,0,0,0);
    setrgb(120+i,0,f*i,f*i); setrgb(141-i,0,f*i,f*i); setrgb(140+i,0,0,0);
    setrgb(150+i,f*i,f*i,f*i); setrgb(171-i,f*i,f*i,f*i); setrgb(170+i,0,0,0);
  end;
  randomize;
  for i:=1 to nofstars do with stars[i] do begin
    xp:=0; yp:=0; col:=0; phase:=0;
    dur:=random(20);
    active:=false;
  end;
  repeat
    vretrace; vretrace;
    for i:=1 to nofstars do with stars[i] do begin
      dec(dur);
      if (not active) and (dur<0) then begin
        active:=true; phase:=0; col:=30*random(6);
        xp:=random(315); yp:=random(195);
      end;
    end;
    for i:=1 to nofstars do with stars[i] do
      if active then begin
        for x:=0 to 4 do for y:=0 to 4 do
          if bitmask[(phase>10),x,y]>0 then
            mem[u_vidseg:(yp+y)*320+xp+x]:=bitmask[(phase>10),x,y]+col+phase;
        inc(phase);
        if phase=21 then begin active:=false; dur:=random(20); end;
      end;
  until keypressed;
  setvideo(u_lm);
end.
