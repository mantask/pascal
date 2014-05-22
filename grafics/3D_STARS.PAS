
program stars; { 3d_STARS.PAS }
uses u_vga,u_pal,u_3d,u_ffcel,u_kb;
const
  speed=2;
  maxstars=300;
var
  points:array[1..maxstars] of record x,y,z:integer; end;

procedure init;
var celpal:pal_type; celpic:pointer; i:word;
begin
  { setup screen - draw GFXFX2-logo in corner }
  getmem(celpic,101*21);
  if cel_load('gfxfx2.cel',celpic,celpal)<>cel_ok then begin
    writeln('An error ocured: ',cel_errstr); halt; end;
  setvideo($13);
  setpal(celpal);
  displaypic(319-101,199-21,celpic,101,21);
  freemem(celpic,101*21);
  { generate random stars }
  randomize;
  for i:=1 to maxstars do
    repeat
      points[i].x:=random(200)-100;
      points[i].y:=random(200)-100;
      points[i].z:=random(300)-100;
    until (points[i].x<>0) and (points[i].y<>0);
end;

procedure dostars;
var
  xp,yp:array[1..maxstars] of integer;
  i:word;
begin
  fillchar(xp,sizeof(xp),0); { clear prev-pos-arrays at start }
  fillchar(yp,sizeof(yp),0);
  repeat
    vretrace;
    for i:=1 to maxstars do begin
      { clear previous position }
      if (xp[i]>=0) and (xp[i]<=319) and (yp[i]>=0) and (yp[i]<=199) then
        if getpixel(xp[i],yp[i])<40 then putpixel(xp[i],yp[i],0);
      { move star to viewer }
      if points[i].z<(200-speed) then inc(points[i].z,speed) else begin
        points[i].z:=-100; { back to far and new x and y positions }
        repeat
          points[i].x:=random(200)-100;
          points[i].y:=random(200)-100;
        until (points[i].x<>0) and (points[i].y<>0);
      end;
      { convert 3d position to 2d screen-coords }
      conv3dto2d(xp[i],yp[i],points[i].x,points[i].y,points[i].z);
      { transfer stars to mid-point of screen }
      inc(xp[i],160); inc(yp[i],100);
      { draw new position }
      if (xp[i]>=0) and (xp[i]<=319) and (yp[i]>=0) and (yp[i]<=199) then
        if getpixel(xp[i],yp[i])<40 then putpixel(xp[i],yp[i],(points[i].z+100) div 9);
    end;
  until keypressed;
end;

begin
  init;
  dostars;
  setvideo(u_lm);
end.
