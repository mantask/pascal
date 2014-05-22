
program voxel_landscape; { VOXEL.PAS }
{ Kinda slow on 386-, works great on 486+ though, by Jeroen Bouwens }
uses u_vga,u_pal,u_kb;

{ create landscape in 2d, color is height -----------------------------------}

function ncol(mc,n,dvd:integer):byte; begin
  ncol:=((mc+n-random(n)) div dvd) mod 245; end;

procedure subdivide(x1,y1,x2,y2:word);
var xn,yn,dxy,p1,p2,p3,p4:word;
begin
  if (x2-x1<2) and (y2-y1<2) then exit;
  p1:=mem[u_vidseg:320*y1+x1];
  p2:=mem[u_vidseg:320*y2+x1];
  p3:=mem[u_vidseg:320*y1+x2];
  p4:=mem[u_vidseg:320*y2+x2];
  xn:=(x2+x1) shr 1; yn:=(y2+y1) shr 1;
  dxy:=5*(x2-x1+y2-y1) div 3;
  if mem[u_vidseg:320*y1+xn]=0 then mem[u_vidseg:320*y1+xn]:=ncol(p1+p3,dxy,2);
  if mem[u_vidseg:320*yn+x1]=0 then mem[u_vidseg:320*yn+x1]:=ncol(p1+p2,dxy,2);
  if mem[u_vidseg:320*yn+x2]=0 then mem[u_vidseg:320*yn+x2]:=ncol(p3+p4,dxy,2);
  if mem[u_vidseg:320*y2+xn]=0 then mem[u_vidseg:320*y2+xn]:=ncol(p2+p4,dxy,2);
  mem[u_vidseg:320*yn+xn]:=ncol(p1+p2+p3+p4,dxy,4);
  subdivide(x1,y1,xn,yn); subdivide(xn,y1,x2,yn);
  subdivide(x1,yn,xn,y2); subdivide(xn,yn,x2,y2);
end;

{ voxelize: remap 2d scape to 3d --------------------------------------------}

procedure voxelize(landscape:pointer; p,q,r : integer);
var oldy:pointer; bo,ho:word; i,j,x,y1,v,y0,sc,y2,y,if1,h1,c,u:integer;
begin
  getmem(oldy,320);
  fillchar(oldy^,320,101);
  for v:=50 downto 0 do begin                                        { depth }
    y0:=199-v+(25600 div (v+1)) shr 8+(r shl 1) div (v+1); { y-coord for high 0 }
    u:=p shl 8-v shl 7-5120;             { u-coord of screen-position (0,y0) }
    c:=(v shl 8+10240) div 320;                   { add-constant for u-coord }
    sc:=256-(v shl 8) div 100;                 { scaling-constant for height }
    bo:=ofs(landscape^)+320*((v+q) mod 200);
    for x:=0 to 319 do begin                                         { width }
      h1:=mem[seg(landscape^):bo+(u shr 8) mod 320];
      y1:=y0-(h1*sc) shr 8;
      if y1>199 then y1:=199;
      if y1>mem[seg(oldy^):ofs(oldy^)+x] then begin                 
        ho:=mem[seg(oldy^):ofs(oldy^)+x]*320+x{+so};
        for i:=mem[seg(oldy^):ofs(oldy^)+x] to y1 do begin          { height }
         mem[destseg:ho]:=h1;
         inc(ho,320);
        end;
      end;
      u:=u+c;
      mem[seg(oldy^):ofs(oldy^)+x]:=y1;
    end;
  end;
  freemem(oldy,320);
end;

{ init, setup and main ------------------------------------------------------}

var virscr,plasma:pointer; i,j:word;
begin
  setvideo($13);
  for i:=1 to 255 do setrgb(i,32+i div 8,i div 6,i div 6);
  mem[u_vidseg:0]:=128;
  mem[u_vidseg:320*199]:=128;
  mem[u_vidseg:320*199+319]:=128;
  mem[u_vidseg:319]:=128;
  randomize;
  subdivide(0,0,319,199);                          { create plasma-landscape }

  for i:=0 to 199 do for j:=0 to 319 do                           { smoothen }
    mem[u_vidseg:320*i+j]:=
      (mem[u_vidseg:320*i+j]+mem[u_vidseg:320*i+j-3]+
      mem[u_vidseg:320*i+j+3]+mem[u_vidseg:320*(i+3)+j]) shr 2;

  getmem(plasma,64000);                 {store the plasma landscape in memory}
  for i:=0 to 199 do for j:=0 to 320 do
    mem[seg(plasma^):ofs(plasma^)+320*i+j]:=mem[u_vidseg:320*i+j];

  {create and show 3d-landscape}
  getmem(virscr,64000);
  destenation:=virscr; destseg:=seg(destenation^);
  repeat
    cls(virscr,64000);
    voxelize(plasma,130,i,mem[seg(plasma^):ofs(plasma^)+320*i+130]);
    flip(virscr,vidptr,64000);
    i:=(i+4) mod 200;
  until keypressed;
  freemem(plasma,64000);
  freemem(virscr,64000);
  setvideo(u_lm);
end.
